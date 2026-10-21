![AXDocs](./.github/assets/griddo-axdocs.png)

# Griddo AX Docs for Cursor

Gives Cursor the official documentation of the Griddo backoffice (Author Experience), the DXP designed for universities. Ask how to do something in Griddo and the agent answers from the documentation, linking the exact page on [docs.griddo.io](https://docs.griddo.io).

## What it includes

- An MCP server (`griddo-docs`, remote, no authentication, read-only) with three tools:
  - `search_griddo_editor_docs`: ranked excerpts in Spanish or English, each with its canonical URL.
  - `get_griddo_editor_doc`: the full Markdown of one page.
  - `list_griddo_editor_docs`: every page, grouped by section.
- A skill (`griddo-backoffice-docs`) that tells the agent when and how to use the server.

## Install

Install from the Cursor Marketplace, or add the server manually to `.cursor/mcp.json` (project) or `~/.cursor/mcp.json` (global):

```json
{
  "mcpServers": {
    "griddo-docs": {
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

## License

MIT. See [LICENSE](LICENSE).
