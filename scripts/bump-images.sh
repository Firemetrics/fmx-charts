#!/bin/bash
#
# Bump container image tags across the parent chart and the leaf charts in one
# step, and verify that the two layers never drift apart.
#
# Every image version lives in at least two places: the parent chart
# (charts/fmx-instance/values.yaml), which is what deployed clusters use, and
# the leaf chart's own values.yaml, which applies when a leaf is rendered
# without the parent. This script keeps them in sync by rewriting every
# occurrence of a known image repository, wherever it appears.
#
# Usage:
#   ./scripts/bump-images.sh --firemetrics v0.14.0 [--panel v1.10.0 ...]
#   ./scripts/bump-images.sh --list          # show current tags
#   ./scripts/bump-images.sh --check         # fail if the layers have drifted
#   ./scripts/bump-images.sh --dry-run ...   # show what would change

set -eo pipefail

cd "$(dirname "$0")" && cd ..

CHARTS_DIR="./charts"
PARENT_VALUES="$CHARTS_DIR/fmx-instance/values.yaml"

# Registry of bumpable images: "<flag> <image repository>".
# Images sharing a flag share a tag and are bumped together.
REGISTRY="
firemetrics ghcr.io/firemetrics/fuego
firemetrics ghcr.io/firemetrics/dicom_receiver
firemetrics ghcr.io/firemetrics/spilo17
panel ghcr.io/firemetrics/fmx-panel
grafana ghcr.io/firemetrics/firemetrics-dashboards
hapi ghcr.io/firemetrics/fmx-hapi-facade
keycloak quay.io/keycloak/keycloak
dicomweb ghcr.io/umessen/dicom-rst-s3
loki grafana/loki
alloy grafana/alloy
spilo-base ghcr.io/zalando/spilo-17
curl curlimages/curl
"

# The Spilo image tag is spiloImagePrefix + firemetricsVersion.
spilo_prefix() {
  sed -nE 's/^spiloImagePrefix: *"?([^"]*)"? *$/\1/p' "$PARENT_VALUES"
}

values_files() {
  find "$CHARTS_DIR" -name values.yaml | sort
}

repos_for_flag() {
  echo "$REGISTRY" | awk -v f="$1" '$1 == f { print $2 }'
}

all_flags() {
  echo "$REGISTRY" | awk 'NF { print $1 }' | awk '!seen[$0]++'
}

flag_for_repo() {
  echo "$REGISTRY" | awk -v r="$1" '$2 == r { print $1 }'
}

# All tags a repository currently carries, as "<tag> <file>" lines.
tags_for_repo() {
  local repo="$1" file
  local esc="${repo//./\\.}"
  for file in $(values_files); do
    { grep -oE "(^|[[:space:]\"'])${esc}:[A-Za-z0-9._-]+" "$file" 2>/dev/null || true; } \
      | sed -E "s|.*${esc}:||" \
      | while read -r tag; do echo "$tag $file"; done
  done
}

# Detect sed in-place flag syntax (matches release-charts.sh).
if [[ "$OSTYPE" == "darwin"* ]]; then
  SED_INPLACE=("sed" "-i" "" "-E")
else
  SED_INPLACE=("sed" "-i" "-E")
fi

DRY_RUN=""
ACTION="bump"
BUMPS=""

usage() {
  echo "Usage: $0 [--dry-run] --<component> <tag> [--<component> <tag> ...]"
  echo "       $0 --list | --check"
  echo
  echo "Components:"
  local flag
  for flag in $(all_flags); do
    printf '  --%-12s %s\n' "$flag" "$(repos_for_flag "$flag" | tr '\n' ' ')"
  done
  echo
  echo "--firemetrics bumps fuego, dicom_receiver and spilo17 together and also"
  echo "sets firemetricsVersion in $PARENT_VALUES."
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --list) ACTION="list"; shift ;;
    --check) ACTION="check"; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    --*)
      flag="${1#--}"
      if [[ -z "$(repos_for_flag "$flag")" ]]; then
        echo "Error: unknown component '--$flag'" >&2
        echo >&2
        usage >&2
        exit 1
      fi
      if [[ -z "$2" || "$2" == --* ]]; then
        echo "Error: --$flag requires a tag" >&2
        exit 1
      fi
      BUMPS="$BUMPS$flag $2"$'\n'
      shift 2
      ;;
    *)
      echo "Error: unexpected argument '$1'" >&2
      exit 1
      ;;
  esac
done

# --list: current tag of every known image.
if [[ "$ACTION" == "list" ]]; then
  echo "firemetricsVersion: $(sed -nE 's/^firemetricsVersion: *"?([^"]*)"? *$/\1/p' "$PARENT_VALUES")"
  echo "$REGISTRY" | awk 'NF' | while read -r flag repo; do
    tags="$(tags_for_repo "$repo" | awk '{ print $1 }' | sort -u | tr '\n' ' ')"
    printf '%-12s %-45s %s\n' "--$flag" "$repo" "$tags"
  done
  exit 0
fi

# Drift check: every occurrence of a repository must carry the same tag, and
# the firemetrics group must match firemetricsVersion.
run_check() {
  local drift=0 flag repo distinct fmv expected

  echo "$REGISTRY" | awk 'NF' | while read -r flag repo; do
    distinct="$(tags_for_repo "$repo" | awk '{ print $1 }' | sort -u | wc -l | tr -d ' ')"
    if [[ "$distinct" -gt 1 ]]; then
      echo "DRIFT: $repo is pinned to more than one tag:" >&2
      tags_for_repo "$repo" | sort -u | sed 's/^/  /' >&2
      echo drift >> "$DRIFT_MARKER"
    fi
  done

  fmv="$(sed -nE 's/^firemetricsVersion: *"?([^"]*)"? *$/\1/p' "$PARENT_VALUES")"
  for repo in $(repos_for_flag firemetrics); do
    expected="$fmv"
    [[ "$repo" == */spilo17 ]] && expected="$(spilo_prefix)$fmv"
    tags_for_repo "$repo" | sort -u | while read -r tag file; do
      if [[ "$tag" != "$expected" ]]; then
        echo "DRIFT: $file pins $repo:$tag; firemetricsVersion $fmv implies $repo:$expected" >&2
        echo drift >> "$DRIFT_MARKER"
      fi
    done
  done

  [[ -s "$DRIFT_MARKER" ]] && return 1
  return 0
}

DRIFT_MARKER="$(mktemp)"
trap 'rm -f "$DRIFT_MARKER"' EXIT

if [[ "$ACTION" == "check" ]]; then
  if run_check; then
    echo "OK: parent and leaf image tags are consistent."
    exit 0
  fi
  exit 1
fi

if [[ -z "$BUMPS" ]]; then
  usage >&2
  exit 1
fi

# Rewrite every occurrence of <repo>:<anything> to <repo>:<tag>.
rewrite() {
  local repo="$1" tag="$2" esc file changed
  esc="${repo//./\\.}"
  for file in $(values_files); do
    grep -qE "(^|[[:space:]\"'])${esc}:" "$file" || continue
    if [[ -n "$DRY_RUN" ]]; then
      changed="$(grep -nE "(^|[[:space:]\"'])${esc}:[A-Za-z0-9._-]+" "$file" \
        | grep -v "${esc}:${tag}\([^A-Za-z0-9._-]\|$\)" || true)"
      [[ -n "$changed" ]] && echo "$changed" | sed "s|^|  $file:|"
    else
      "${SED_INPLACE[@]}" "s#(^|[[:space:]\"'])${esc}:[A-Za-z0-9._-]+#\1${repo}:${tag}#g" "$file"
    fi
  done
}

while read -r flag tag; do
  [[ -z "$flag" ]] && continue
  echo "Bumping --$flag to $tag"
  for repo in $(repos_for_flag "$flag"); do
    target="$tag"
    if [[ "$flag" == "firemetrics" && "$repo" == */spilo17 ]]; then
      target="$(spilo_prefix)$tag"
    fi
    rewrite "$repo" "$target"
  done
  if [[ "$flag" == "firemetrics" ]]; then
    if [[ -n "$DRY_RUN" ]]; then
      echo "  $PARENT_VALUES: firemetricsVersion -> $tag"
    else
      "${SED_INPLACE[@]}" "s|^firemetricsVersion:.*|firemetricsVersion: \"$tag\"|" "$PARENT_VALUES"
    fi
  fi
done <<< "$BUMPS"

if [[ -n "$DRY_RUN" ]]; then
  echo "Dry run: no files changed."
  exit 0
fi

echo
if run_check; then
  echo "OK: parent and leaf image tags are consistent."
else
  exit 1
fi

echo
echo "Changed files:"
git diff --name-only -- "$CHARTS_DIR" | sed 's/^/  /'
echo
echo "Next: commit with a conventional-commit message, then ./scripts/release-charts.sh"
