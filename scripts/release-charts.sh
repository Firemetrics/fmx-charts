#!/bin/bash

set -eo pipefail

cd "$(dirname "$0")" && cd ..

if ! git cliff --version &> /dev/null; then
  echo "Error: git-cliff is not installed"
  exit 1
fi

TARGET_VERSION="$(git cliff --bumped-version | sed 's/^v//')"
git cliff --bump -o

CHARTS_DIR="./charts"

# Detect sed in-place flag syntax
if [[ "$OSTYPE" == "darwin"* ]]; then
  SED_INPLACE=("sed" "-i" "")
else
  SED_INPLACE=("sed" "-i")
fi

for chart in "$CHARTS_DIR"/*/; do
  # Skip work-in-progress directories that are not charts yet.
  [ -f "$chart/Chart.yaml" ] || { echo "Skipping $chart (no Chart.yaml)"; continue; }
  "${SED_INPLACE[@]}" -e "s/^version:.*/version: $TARGET_VERSION/" "$chart/Chart.yaml"
done

helm-docs

git add "$CHARTS_DIR" ./CHANGELOG.md
git commit -m "v$TARGET_VERSION"
# Force a lightweight tag (matches existing release history) even when
# tag.gpgSign is enabled globally, which would otherwise turn `git tag`
# into a signed annotated tag and fail without a message.
git -c tag.gpgSign=false tag "v$TARGET_VERSION"

