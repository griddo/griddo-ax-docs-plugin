---
name: griddo-backoffice-docs
description: Answer questions about using the Griddo backoffice (pages, modules, templates, content types, forms, media gallery, roles, publishing) from the official documentation. Use when a content author or site administrator asks how to do something in Griddo.
---

# Griddo backoffice documentation

Use the `griddo-ax-docs` MCP server to answer questions about the Griddo backoffice (Author Experience).

1. Call `search_griddo_editor_docs` with the user's question. Pass `lang: "en"` when the user writes in English; Spanish is the default and the most complete version.
2. If an excerpt is not enough to answer accurately, call `get_griddo_editor_doc` with the page path returned by the search.
3. Call `list_griddo_editor_docs` when the user asks what the documentation covers.
4. Answer from what the documentation says and cite the canonical `docs.griddo.io` URL of each page used.

Scope: backoffice usage only. Developer topics (`@griddo/core`, schemas, module code, API, SDK) are covered by a separate Griddo DX Docs server.
