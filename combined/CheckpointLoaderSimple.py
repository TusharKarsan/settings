import json
import os

# Adjust these to match your WSL Docker paths
WORKFLOW_DIR = "./ComfyUI-Workflows"
MODEL_DIR = "./models/checkpoints"

def repair_workflows():
    # Get the first available checkpoint in your folder
    available_models = [f for f in os.listdir(MODEL_DIR) if f.endswith(('.safetensors', '.ckpt'))]
    if not available_models:
        print("No models found in checkpoints folder!")
        return
    
    default_model = available_models[0]

    for filename in os.listdir(WORKFLOW_DIR):
        if filename.endswith(".json"):
            path = os.path.join(WORKFLOW_DIR, filename)
            with open(path, 'r') as f:
                data = json.load(f)
            
            # Find and update CheckpointLoader nodes
            updated = False
            for node_id, node in data.items():
                if node.get("class_type") == "CheckpointLoaderSimple":
                    node["inputs"]["ckpt_name"] = default_model
                    updated = True
            
            if updated:
                with open(path, 'w') as f:
                    json.dump(data, f, indent=4)
                print(f"✅ Updated {filename} to use {default_model}")

if __name__ == "__main__":
    repair_workflows()
