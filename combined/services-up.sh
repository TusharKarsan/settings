#!/usr/bin/env bash

export BASE_DIR=/home/tushar/data
cd /home/tushar/settings/combined
# docker compose build --no-cache
# docker compose build --no-cache comfyui
# docker compose build --no-cache mcp-bridge
docker compose up -d
cd /home/tushar
