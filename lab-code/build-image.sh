#!/usr/bin/env bash

BASE_DIR="$HOME/data/comfyui/custom_nodes"

echo "Scanning: $BASE_DIR"
echo

for dir in "$BASE_DIR"/*; do
    if [ -d "$dir/.git" ]; then
        echo "=== $(basename "$dir") ==="
        git -C "$dir" pull --ff-only
        echo
    fi
done

export BASE_DIR=/home/tushar/data
cd /home/tushar/settings/combined
# docker compose build --no-cache comfyui
# docker compose build --no-cache mcp-bridge
docker compose pull
docker compose build --no-cache --pull
docker builder prune -a -f
# docker system prune -f
# cd /home/tushar
