import json
import os

# Updated paths based on your repo structure
# It's likely they are in ../ComfyUI-Workflows relative to 'combined'
WORKFLOW_DIR = "../ComfyUI-Workflows" 
# This needs to point to wherever your .safetensors files are on the WSL disk
MODEL_DIR = "/home/tushar/data/comfyui/models/checkpoints" 

def repair_workflows():
    # Attempt to find the models folder if the default fails
    search_path = MODEL_DIR
    if not os.path.exists(search_path):
        # Let's try to find it relative to the script
        potential_paths = [
            "./comfyui/models/checkpoints",
            "../comfyui/models/checkpoints",
            "../models/checkpoints"
        ]
        for p in potential_paths:
            if os.path.exists(p):
                search_path = p
                break
    
    if not os.path.exists(search_path):
        print(f"❌ Error: Could not find checkpoints folder at {search_path}")
        print("Please check where your .safetensors files are located.")
        return

    available_models = [f for f in os.listdir(search_path) if f.endswith(('.safetensors', '.ckpt'))]
    
    if not available_models:
        print(f"📂 Found folder {search_path}, but it is empty!")
        return
    
    default_model = available_models[0]
    print(f"Found model: {default_model}")

    if not os.path.exists(WORKFLOW_DIR):
        print(f"❌ Workflow directory {WORKFLOW_DIR} not found.")
        return

    for filename in os.listdir(WORKFLOW_DIR):
        if filename.endswith(".json"):
            path = os.path.join(WORKFLOW_DIR, filename)
            try:
                with open(path, 'r') as f:
                    data = json.load(f)
                
                updated = False
                # ComfyUI JSONs can be 'API format' (list) or 'Web Format' (dict)
                # This handles both
                nodes = data.values() if isinstance(data, dict) else data

                for node in nodes:
                    if node.get("class_type") == "CheckpointLoaderSimple":
                        node["inputs"]["ckpt_name"] = default_model
                        updated = True
                
                if updated:
                    with open(path, 'w') as f:
                        json.dump(data, f, indent=4)
                    print(f"✅ Repaired: {filename}")
            except Exception as e:
                print(f"⚠️ Could not process {filename}: {e}")

if __name__ == "__main__":
    repair_workflows()
