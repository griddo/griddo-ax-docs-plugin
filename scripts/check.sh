#!/usr/bin/env bash
set -euo pipefail

# check.sh — Verify that every platform's package is complete and consistent.
#
# The repo ships one plugin to several marketplaces, each with its own manifest
# (.cursor-plugin/plugin.json for Cursor, .codex-plugin/plugin.json for
# ChatGPT/Codex). They share the skill, the MCP config and the assets, so the
# usual failure is drift: a version bumped in one manifest only, or the two MCP
# files (mcp.json for Cursor, .mcp.json for Codex and cursor.directory) no
# longer matching. Run before every release; package-openai.sh runs it too.

cd "$(dirname "$0")/.."

CURSOR=".cursor-plugin/plugin.json"
CODEX=".codex-plugin/plugin.json"
SHARED_FIELDS='{name, version, description, author, homepage, repository, license, keywords}'

errors=0

fail() {
  echo "✗ $1" >&2
  errors=$((errors + 1))
}

ok() {
  echo "✓ $1"
}

for manifest in "$CURSOR" "$CODEX" mcp.json .mcp.json; do
  if ! jq empty "$manifest" 2>/dev/null; then
    fail "$manifest is missing or not valid JSON"
  fi
done
[[ $errors -eq 0 ]] || exit 1

if [[ "$(jq -S "$SHARED_FIELDS" "$CURSOR")" == "$(jq -S "$SHARED_FIELDS" "$CODEX")" ]]; then
  ok "Shared manifest fields match"
else
  fail "Shared manifest fields differ between $CURSOR and $CODEX:"
  diff <(jq -S "$SHARED_FIELDS" "$CURSOR") <(jq -S "$SHARED_FIELDS" "$CODEX") >&2 || true
fi

version="$(jq -r .version "$CURSOR")"
if [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  ok "Version $version is semver"
else
  fail "Version '$version' is not semver (X.Y.Z)"
fi

if cmp -s mcp.json .mcp.json; then
  ok "mcp.json and .mcp.json are identical"
else
  fail "mcp.json and .mcp.json differ"
fi

# Every path a manifest points to must exist.
check_path() {
  local manifest="$1" path="$2"
  if [[ -z "$path" || "$path" == "null" ]]; then
    return
  fi
  if [[ -e "${path#./}" ]]; then
    ok "$manifest → $path"
  else
    fail "$manifest points to $path, which does not exist"
  fi
}

check_path "$CURSOR" "$(jq -r .logo "$CURSOR")"
check_path "$CURSOR" "$(jq -r .skills "$CURSOR")"
check_path "$CURSOR" "$(jq -r .mcpServers "$CURSOR")"
check_path "$CODEX" "$(jq -r .skills "$CODEX")"
check_path "$CODEX" "$(jq -r .mcpServers "$CODEX")"
check_path "$CODEX" "$(jq -r .interface.logo "$CODEX")"
check_path "$CODEX" "$(jq -r .interface.composerIcon "$CODEX")"

# A skill's frontmatter name must match its folder name.
for skill_dir in skills/*/; do
  skill="$(basename "$skill_dir")"
  if [[ ! -f "$skill_dir/SKILL.md" ]]; then
    fail "skills/$skill has no SKILL.md"
  elif grep -qx "name: $skill" "$skill_dir/SKILL.md"; then
    ok "skills/$skill/SKILL.md"
  else
    fail "skills/$skill/SKILL.md frontmatter name does not match its folder"
  fi
done

# Draft values left from the OpenAI submission template.
if grep -q "REPLACE_WITH" "$CODEX"; then
  fail "$CODEX still has REPLACE_WITH placeholders"
fi

if [[ $errors -gt 0 ]]; then
  echo "$errors problem(s) found." >&2
  exit 1
fi
echo "All checks passed."
