"""DuckDuckGo Web Search MCP Server"""

import asyncio
import sys
from typing import List

from ddgs import DDGS
from mcp.server.mcpserver import MCPServer

# Configure logging
import logging

logging.basicConfig(level=logging.INFO, stream=sys.stderr, format="%(name)s: %(levelname)s %(message)s")
logging.getLogger("ddgs").setLevel(logging.WARNING)


# Create the MCP server
server = MCPServer(
    name="ddgs-mcp-server",
    version="0.1.0",
    description="Web search using DuckDuckGo",
)


@server.tool(description="Search the web using DuckDuckGo")
async def search_web(query: str, max_results: int = 5) -> str:
    """Search the web using DuckDuckGo and return search results.

    Args:
        query: The search query string
        max_results: Maximum number of results to return (default: 5, max: 10)

    Returns:
        A formatted string containing search results with title, URL, and snippet
    """
    max_results = min(max(max_results, 1), 10)

    ddgs = DDGS()
    results = ddgs.text(query, max_results=max_results)

    if not results:
        return f"No results found for: {query}"

    formatted = f"Search results for '{query}' ({len(results)} results):\n\n"

    for i, result in enumerate(results, 1):
        title = result.get("title", "No title")
        url = result.get("href", "")
        snippet = result.get("answer", result.get("body", ""))
        formatted += f"{i}. {title}\n   {url}\n   {snippet}\n\n"

    return formatted.rstrip()


async def main():
    """Run the DuckDuckGo MCP server over stdio."""
    await server.run_stdio_async()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
