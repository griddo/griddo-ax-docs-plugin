#!/usr/bin/env bash
set -euo pipefail

# set-version.sh — Set the same version in every platform manifest.
#
# Usage: scripts/set-version.sh 0.2.0
#
# Edits the "version" line in place rather than rewriting the files with jq,
# so each manifest keeps its own formatting.

cd "$(dirname "$0")/.."

VERSION="${1:-}"
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Usage: $0 X.Y.Z" >&2
  exit 1
fi

for manifest in .cursor-plugin/plugin.json .codex-plugin/plugin.json; do
  sed -i.bak -E "s/^  \"version\": \"[^\"]*\",$/  \"version\": \"$VERSION\",/" "$manifest"
  rm "$manifest.bak"
  echo "$manifest → $(jq -r .version "$manifest")"
done

scripts/check.sh
