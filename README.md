# Server Settings & Docker Orchestration

This repository contains the configuration and orchestration scripts for my local services, including ComfyUI and networking tools.

## 🏗 Structure

- `/data`: Persistent storage for all services (ignored by git).
- `/old_2_dc`: Archive of previous configuration files for reference.
- `services-up.sh`: Bootstraps the environment and starts containers.
- `services-down.sh`: Safely stops all active services.

## 🚀 Getting Started

### Prerequisites
- Docker & Docker Compose
- Tailscale (for remote access)

### Usage
To start the services with the correct environment variables (setting the `BASE_DIR` for volume persistence):

```bash
chmod +x services-up.sh services-down.sh
./services-up.sh

## Before update on 2026-02-13

```yaml
services:

  # ---
  # --- AI Interfaces & Orchestration ---
  # ---

  openwebui:
    image: ghcr.io/open-webui/open-webui:cuda
    container_name: openwebui
    ports:
      - "3000:8080"
    volumes:
      - ${BASE_DIR}/openwebui/data:/app/backend/data
    environment:
      - OLLAMA_BASE_URL=http://host.docker.internal:11434
      - COMFYUI_BASE_URL=http://comfyui:8188
      - WEBUI_AUTH=false
      - ENABLE_RAG_WEB_SEARCH=True
      - RAG_WEB_SEARCH_ENGINE=searxng
      - SEARXNG_QUERY_URL=http://searxng:8080/search?format=json&q=<query>
    extra_hosts:
      - "host.docker.internal:host-gateway"
    depends_on:
      - searxng
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    restart: always

  anythingllm:
    image: mintplexlabs/anythingllm:latest
    container_name: anythingllm
    ports:
      - "3001:3001"
    environment:
      - VECTOR_DB_TYPE=qdrant
      - VECTOR_DB_HOST=qdrant
      - VECTOR_DB_PORT=6333
      - VECTOR_DB_API_KEY=qdrant
      - EXTERNAL_LLM_ENDPOINT=http://host.docker.internal:11434
      - EXTERNAL_LLM_MODEL=qwen3-coder:latest
      - STORAGE_DIR=/app/server/storage
    extra_hosts:
      - "host.docker.internal:host-gateway"
    volumes:
      - ${BASE_DIR}:/anythingLLM/app/server/storage
      - ${BASE_DIR}/anythingLLM/hotdir:/app/collector/hotdir
      - ./anythingLLM/.env:/app/server/.env
    depends_on:
      - qdrant
    restart: unless-stopped

  # ---
  # --- Image Generation ---
  # ---

  comfyui:
    build:
      context: .
      dockerfile: Dockerfile.comfyui
    container_name: comfyui
    ports:
      - "8188:8188"
    environment:
      - WEB_ENABLE_AUTH=false
      - NVIDIA_VISIBLE_DEVICES=all
      - NVIDIA_DRIVER_CAPABILITIES=compute,utility
      - YOLO_CONFIG_DIR=/app/user/default/ultralytics
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    volumes:
      - ${BASE_DIR}/comfyui/models:/app/models
      - ${BASE_DIR}/comfyui/input:/app/input
      - ${BASE_DIR}/comfyui/output:/app/output
      - ${BASE_DIR}/comfyui/custom_nodes:/app/custom_nodes
    restart: always

  # ---
  # --- Search & Metadata ---
  # ---

  searxng:
    image: searxng/searxng:latest
    container_name: searxng
    ports:
      - "8081:8080"
    volumes:
      - ./searxng:/etc/searxng
    environment:
      - SEARXNG_BASE_URL=http://localhost:8081/
      - SEARXNG_REDIS_URL=redis://redis:6379/0
    depends_on:
      - redis
    restart: always

  # ---
  # --- Databases ---
  # ---

  qdrant:
    image: qdrant/qdrant:latest
    container_name: qdrant
    ports:
      - "6333:6333"
      - "6334:6334"
    volumes:
      - ${BASE_DIR}/qdrant/storage:/qdrant/storage
    restart: unless-stopped

  mcp-bridge:
    build:
      context: .
      dockerfile: Dockerfile.qdrant-mcp
    container_name: mcp-bridge
    environment:
      - QDRANT_URL=http://qdrant:6333
      - FASTMCP_HOST=0.0.0.0
      - FASTMCP_PORT=8000
      - UVICORN_HOST=0.0.0.0
      - UVICORN_PORT=8000
      - FASTEMBED_CACHE_PATH=/app/fastembed_cache
    ports:
      - "8000:8000"
    volumes:
      - ${BASE_DIR}/qdrant/mcp:/app/fastembed_cache
    depends_on:
      - qdrant
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    container_name: redis
    command: redis-server --save 60 1 --loglevel warning
    restart: always
```
