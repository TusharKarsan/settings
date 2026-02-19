#!/usr/bin/env bash

export BASE_DIR=/home/tushar/data
cd /home/tushar/settings/combined
# docker compose pull
# docker compose build --no-cache comfyui
# docker compose build --no-cache mcp-bridge
docker compose build --no-cache --pull
docker system prune -f
docker builder prune -a -f
# cd /home/tushar
