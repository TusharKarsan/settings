#!/usr/bin/env bash

# export CR_PAT=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
# echo $CR_PAT | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin

set -e

BASE_DIR="$HOME/ai-stack"

echo "Creating AI stack directories in: $BASE_DIR"

mkdir -p \
  "$BASE_DIR/comfyui/models/checkpoints" \
  "$BASE_DIR/comfyui/models/loras" \
  "$BASE_DIR/comfyui/models/controlnet" \
  "$BASE_DIR/comfyui/output" \
  "$BASE_DIR/comfyui/data" \
  "$BASE_DIR/openwebui/data"

echo "Directory structure created."
echo
echo "Next steps:"
echo "  cd $BASE_DIR"
echo "  place docker-compose.yml here"
echo "  docker compose up -d"
