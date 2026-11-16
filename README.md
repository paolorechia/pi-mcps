# pi-mcps

Docker container for running [Pi coding agent](https://pi.dev/) with DuckDuckGo web search built in.

## Quick start

Add this alias to your `~/.zshrc` or `~/.bashrc`:

```bash
alias pi-docker='docker run --rm -it -v "$PWD:/workspace" -v pi-agent-home:/root/.pi/agent pi-mcps-pi'
```

Then use it:

```bash
# Build the image (first run only, ~2 min)
docker build -f Dockerfile.pi -t pi-mcps-pi .

# Run Pi
pi-docker
```

- MCP server `ddgs` is baked in with `direct` exposure → `search_web` is always available.
- Sessions and config persist in the `pi-agent-home` Docker volume.
- Volume mount `./ → /workspace` gives you the project directory.

## Updating

```bash
docker build -f Dockerfile.pi -t pi-mcps-pi .
```

## Files

| File | Purpose |
|---|---|
| `Dockerfile.pi` | Builds the container image |
| `ddgs-mcp-server.py` | DuckDuckGo MCP server script (baked into image) |
| `mcp-container.json` | MCP config for inside the container |
| `models-host.json` | Models pointing to `host.docker.internal:8000` |
| `models-compose.json` | Models pointing to `splash:8000` (for docker-compose MODE 2) |
