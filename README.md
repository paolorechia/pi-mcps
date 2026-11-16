# pi-mcps

Docker container for running [Pi coding agent](https://pi.dev/) with DuckDuckGo web search built in.

## Quick start

```bash
# Read-write workspace (can modify files in the container)
pi-web

# Read-only workspace (safest for project dirs)
pi-web-ro
```

First run builds the image (~2 min). After that it just starts Pi.

- MCP server `ddgs` is baked in with `direct` exposure → `search_web` is always available.
- Sessions and config persist in the `pi-agent-home` Docker volume.
- Volume mount `./ → /workspace` gives you the project directory.

## Shell aliases

Add this to your `~/.zshrc` or `~/.bashrc`:

```bash
alias pi-web='bash /Users/paolo/dev/pi-mcps/run-web.sh'
alias pi-web-ro='bash /Users/paolo/dev/pi-mcps/run.sh'
```

Or use the scripts directly:

```bash
bash run-web.sh      # read-write workspace
bash run.sh          # read-only workspace
```

## Files

| File | Purpose |
|---|---|
| `Dockerfile.pi` | Builds the container image |
| `ddgs-mcp-server.py` | DuckDuckGo MCP server script |
| `mcp-container.json` | MCP config for inside the container |
| `mcp-host.json` | MCP config for running on the host (gitignored) |
| `run.sh` | Build + run (read-only workspace) |
| `run-web.sh` | Build + run (read-write workspace) |
| `models-host.json` | Models pointing to `host.docker.internal:8000` |
| `models-compose.json` | Models pointing to `splash:8000` (for docker-compose MODE 2) |

## Updating

```bash
docker build -f Dockerfile.pi -t pi-mcps-pi .
```

Or just run any script — it only builds if the image is missing.
