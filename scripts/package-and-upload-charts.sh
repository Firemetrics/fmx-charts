#!/bin/bash

set -eo pipefail

cd "$(dirname "$0")" && cd ..

if [ -z "$HELM_REPO_URL" ] || [ -z "$HELM_REPO_USERNAME" ] || [ -z "$HELM_REPO_PASSWORD" ]; then
  echo "Please set HELM_REPO_URL, HELM_REPO_USERNAME, and HELM_REPO_PASSWORD environment variables."
  exit 1
fi

CHARTS_DIR="./charts"
OUTPUT_DIR="./packaged"

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

for chart in "$CHARTS_DIR"/*/; do
  helm package "$chart" -d "$OUTPUT_DIR"
done

for tgz in "$OUTPUT_DIR"/*.tgz; do
  curl -fs -u "$HELM_REPO_USERNAME:$HELM_REPO_PASSWORD" --upload-file "$tgz" "$HELM_REPO_URL"
  echo "Successfully uploaded $tgz"
done

