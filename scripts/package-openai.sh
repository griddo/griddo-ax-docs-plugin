#!/usr/bin/env bash
set -euo pipefail

# package-openai.sh — Build the ZIP to upload to the ChatGPT/Codex plugin
# directory (platform.openai.com/plugins).
#
# The ZIP holds only what OpenAI reads from a Codex-format package:
# .codex-plugin/plugin.json, .mcp.json, skills/ and the assets the manifest
# references. It is built with git archive from HEAD, so it always matches what
# is committed and local junk (.DS_Store, ignored files) can never reach it.
#
# Output: dist/griddo-ax-docs-<version>.zip

cd "$(dirname "$0")/.."

PATHS=(.codex-plugin/plugin.json .mcp.json skills assets/icon.png assets/logo.png)

scripts/check.sh >/dev/null

if [[ -n "$(git status --porcelain -- "${PATHS[@]}")" ]]; then
  echo "Error: uncommitted changes in the package files; commit them first:" >&2
  git status --short -- "${PATHS[@]}" >&2
  exit 1
fi

name="$(git show HEAD:.codex-plugin/plugin.json | jq -r .name)"
version="$(git show HEAD:.codex-plugin/plugin.json | jq -r .version)"
out="dist/$name-$version.zip"

mkdir -p dist
rm -f "$out"
git archive --format=zip -o "$out" HEAD "${PATHS[@]}"

echo "Built $out"
unzip -l "$out"
