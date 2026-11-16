#!/usr/bin/env bash
set -e

# ── Build (only if image doesn't exist) ───────────────────────────
if ! docker image inspect pi-mcps-pi >/dev/null 2>&1; then
  echo "→ Building image…"
  docker build -f Dockerfile.pi -t pi-mcps-pi .
fi

# ── Fix common volume issues ─────────────────────────────────────
# 1. Pi crashes on empty models.json, leaving it in the volume
if [ -s ~/.pi/agent/models.json ]; then
  docker run --rm \
    -v pi-agent-home:/data \
    -v ~/.pi/agent:/host \
    alpine cp /host/models.json /data/models.json
  docker run --rm -v pi-agent-home:/data alpine sh -c \
    'sed -i "s|http://localhost:8000|http://host.docker.internal:8000|" /data/models.json'
fi

# 2. mcp.json may have wrong Python path or missing ddgs server
docker run --rm \
  -v pi-agent-home:/data \
  --entrypoint /bin/sh \
  pi-mcps-pi -c '
  test -f /data/mcp.json && {
    grep -q "/usr/bin/python3" /data/mcp.json &&
    cat > /data/mcp.json << "EOF"
{
  "mcpServers": {
    "ddgs": {
      "command": "/opt/venv/bin/python3",
      "args": ["/workspace/ddgs-mcp-server.py"],
      "exposure": "direct"
    }
  }
}
EOF
  }' 2>/dev/null || true

# ── Run ───────────────────────────────────────────────────────────
echo "→ Starting Pi…"
docker run --rm -t \
  -v .:/workspace \
  -v pi-agent-home:/root/.pi/agent \
  -e HF_TOKEN=${HF_TOKEN:-} \
  --name pi \
  pi-mcps-pi
