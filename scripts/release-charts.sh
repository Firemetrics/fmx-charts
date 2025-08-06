#!/bin/bash

set -eo pipefail

cd "$(dirname "$0")" && cd ..

TARGET_VERSION="$1"

if [ -z "$TARGET_VERSION" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

CHARTS_DIR="./charts"

for chart in "$CHARTS_DIR"/*/; do
  sed -i "s/^version:.*/version: $TARGET_VERSION/" "$chart/Chart.yaml"
done

git add "$CHARTS_DIR"
git commit -m "v$TARGET_VERSION"
git tag "v$TARGET_VERSION"

