#!/usr/bin/env bash

# Base directory for your ComfyUI data
BASE_DIR="${HOME}/data/comfyui"

echo "Creating ComfyUI folder structure under: $BASE_DIR"
mkdir -p "$BASE_DIR"

# Core directories
mkdir -p "$BASE_DIR/custom_nodes"
mkdir -p "$BASE_DIR/input"
mkdir -p "$BASE_DIR/output"

# Model directories
mkdir -p "$BASE_DIR/models"

# GGUF‑friendly subfolders
mkdir -p "$BASE_DIR/models/checkpoints"
mkdir -p "$BASE_DIR/models/unet"
mkdir -p "$BASE_DIR/models/vae"
mkdir -p "$BASE_DIR/models/clip"
mkdir -p "$BASE_DIR/models/text_encoder"
mkdir -p "$BASE_DIR/models/diffusion_models"
mkdir -p "$BASE_DIR/models/llm"
mkdir -p "$BASE_DIR/models/whisper"
mkdir -p "$BASE_DIR/models/upscale_models"
mkdir -p "$BASE_DIR/models/embeddings"
mkdir -p "$BASE_DIR/models/lora"
mkdir -p "$BASE_DIR/models/hypernetworks"
mkdir -p "$BASE_DIR/models/style_models"
mkdir -p "$BASE_DIR/models/gligen"
mkdir -p "$BASE_DIR/models/vae_approx"
mkdir -p "$BASE_DIR/models/controlnet"
mkdir -p "$BASE_DIR/models/diffusers"

echo "Cloning custom nodes into: $BASE_DIR/custom_nodes"
cd "$BASE_DIR/custom_nodes"
if [ -d "$BASE_DIR/custom_nodes/ComfyUI-GGUF" ]; then \
    cd "$BASE_DIR/custom_nodes/ComfyUI-GGUF" && git pull; \
else \
    git clone https://github.com/city96/ComfyUI-GGUF "$BASE_DIR/custom_nodes/ComfyUI-GGUF"; \
fi && \
if [ -d "$BASE_DIR/custom_nodes/was-node-suite-comfyui" ]; then \
    cd "$BASE_DIR/custom_nodes/was-node-suite-comfyui" && git pull; \
else \
    git clone https://github.com/WASasquatch/was-node-suite-comfyui "$BASE_DIR/custom_nodes/was-node-suite-comfyui"; \
fi && \
cd "$BASE_DIR"

echo "Setting permissions for container user (UID 1000)..."
sudo chown -R 1000:1000 "$BASE_DIR"

echo "Done."
