set -e

BASE_DIR="$HOME/data"
echo "Creating AI stack directories in: $BASE_DIR"

mkdir -p \
  "$BASE_DIR/openwebui/data"

mkdir -p \
  $BASE_DIR/anythingLLM/storage \
  $BASE_DIR/anythingLLM/hotdir

mkdir -p \
  "$BASE_DIR/comfyui/models/checkpoints" \
  "$BASE_DIR/comfyui/models/loras" \
  "$BASE_DIR/comfyui/models/controlnet" \
  "$BASE_DIR/comfyui/output" \
  "$BASE_DIR/comfyui/input" \
  "$BASE_DIR/comfyui/data"

mkdir -p \
  "$BASE_DIR/qdrant/storage"
