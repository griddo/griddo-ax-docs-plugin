![AXDocs](./.github/assets/griddo-axdocs.png)

# Griddo AX Docs

Gives your AI assistant the official documentation of the Griddo backoffice (Author Experience), the DXP designed for universities. Ask how to do something in Griddo and the agent answers from the documentation, linking the exact page on [docs.griddo.io](https://docs.griddo.io).

Available for Cursor and for ChatGPT and Codex.

## What it includes

- An MCP server (`griddo-ax-docs`, remote, no authentication, read-only) with three tools:
  - `search_griddo_editor_docs`: ranked excerpts in Spanish or English, each with its canonical URL.
  - `get_griddo_editor_doc`: the full Markdown of one page.
  - `list_griddo_editor_docs`: every page, grouped by section.
- A skill (`griddo-backoffice-docs`) that tells the agent when and how to use the server.

## Install

- **Cursor:** install from the Cursor Marketplace or from [Cursor Directory](https://cursor.directory/plugins/griddo-ax-docs).
- **ChatGPT and Codex:** install Griddo AX Docs from the plugin directory.
- **Any MCP client:** add the server manually. In Cursor, use `.cursor/mcp.json` (project) or `~/.cursor/mcp.json` (global):

```json
{
  "mcpServers": {
    "griddo-ax-docs": {
      "url": "https://ax.mcp.griddo.io/mcp"
    }
  }
}
```

## Configuration

None. The server is public and needs no API key.

## Scope

Backoffice usage for content authors, editors and site administrators. Developer topics (`@griddo/core`, schemas, module code, API, SDK) are out of scope.

## Privacy and support

The server receives only your search terms and the paths of the pages it reads.

- Documentation: https://docs.griddo.io/mcp/
- Privacy policy: https://griddo.io/privacy-policy/
- Support: support@griddo.io

## For maintainers

One repo ships the plugin to every marketplace. The skill, the MCP config and the assets are shared; each platform only adds its own manifest.

| Path | Used by |
|---|---|
| `.cursor-plugin/plugin.json` | Cursor Marketplace, Cursor Directory |
| `.codex-plugin/plugin.json` | ChatGPT and Codex plugin directory |
| `skills/` | All |
| `mcp.json` | Cursor Marketplace |
| `.mcp.json` | Cursor Directory, ChatGPT and Codex. Must stay identical to `mcp.json` |
| `assets/logo.png` | All |
| `assets/icon.png` | ChatGPT and Codex (composer icon) |

Changes to the MCP server's tools reach every platform without publishing the plugin. Publish a new version only when the skill, the manifests or the assets change:

1. `scripts/set-version.sh X.Y.Z` sets the version in both manifests and runs `scripts/check.sh`.
2. Commit, tag `vX.Y.Z` and push.
3. **Cursor Marketplace:** updates are reviewed by Cursor before going live. Email marketplace-publishing@cursor.com with the plugin name, the repo and the commit to publish.
4. **Cursor Directory:** reads the repo from GitHub; check that the listing shows the new version.
5. **ChatGPT and Codex:** `scripts/package-openai.sh` builds `dist/griddo-ax-docs-X.Y.Z.zip` from the committed files. Upload it as a new version of the existing plugin at [platform.openai.com/plugins](https://platform.openai.com/plugins) and submit it for review.

## License

MIT. See [LICENSE](LICENSE).
