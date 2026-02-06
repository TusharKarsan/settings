FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

# System dependencies
RUN apt-get update && apt-get install -y \
    git python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Install CUDA-enabled PyTorch (CUDA 12.1 wheels)
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Clone ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /comfyui

WORKDIR /comfyui

# Install ComfyUI dependencies
RUN pip3 install -r requirements.txt

# ---------------------------------------------------------
# Install custom nodes: ComfyUI-GGUF + WAS Node Suite
# ---------------------------------------------------------

# Clone custom nodes into the image
RUN git clone https://github.com/city96/ComfyUI-GGUF /comfyui/custom_nodes/ComfyUI-GGUF && \
    # git clone https://github.com/black-forest-labs/ComfyUI-Flux /comfyui/custom_nodes/ComfyUI-Flux && \
    git clone https://github.com/WASasquatch/was-node-suite-comfyui /comfyui/custom_nodes/was-node-suite-comfyui

# Install Python dependencies for both custom nodes
# (requirements.txt may not exist in both repos, so we install safely)
RUN if [ -f /comfyui/custom_nodes/ComfyUI-GGUF/requirements.txt ]; then \
        pip3 install -r /comfyui/custom_nodes/ComfyUI-GGUF/requirements.txt ; \
    fi && \
    # if [ -f /comfyui/custom_nodes/ComfyUI-Flux/requirements.txt ]; then \
    #     pip3 install -r /comfyui/custom_nodes/ComfyUI-Flux/requirements.txt ; \
    # fi && \
    if [ -f /comfyui/custom_nodes/was-node-suite-comfyui/requirements.txt ]; then \
        pip3 install -r /comfyui/custom_nodes/was-node-suite-comfyui/requirements.txt ; \
    fi

# Explicit installs required by both repos
RUN pip3 install numpy gguf numba

EXPOSE 8188

CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
