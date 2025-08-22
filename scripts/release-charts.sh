#!/bin/bash

set -eo pipefail

cd "$(dirname "$0")" && cd ..

TARGET_VERSION="$1"

if [ -z "$TARGET_VERSION" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

CHARTS_DIR="./charts"

# Detect sed in-place flag syntax
if [[ "$OSTYPE" == "darwin"* ]]; then
  SED_INPLACE=("sed" "-i" "")
else
  SED_INPLACE=("sed" "-i")
fi

for chart in "$CHARTS_DIR"/*/; do
  "${SED_INPLACE[@]}" -e "s/^version:.*/version: $TARGET_VERSION/" "$chart/Chart.yaml"
done

helm-docs

git add "$CHARTS_DIR"
git commit -m "v$TARGET_VERSION"
git tag "v$TARGET_VERSION"

