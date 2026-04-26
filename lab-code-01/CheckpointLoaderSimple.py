import json
import os

WORKFLOW_DIR = "../ComfyUI-Workflows" 
MODEL_DIR = "/home/tushar/data/comfyui/models/checkpoints" 

def repair_workflows():
    if not os.path.exists(MODEL_DIR):
        print(f"❌ Error: Could not find checkpoints folder at {MODEL_DIR}")
        return

    available_models = [f for f in os.listdir(MODEL_DIR) if f.endswith(('.safetensors', '.ckpt'))]
    
    if not available_models:
        print(f"📂 Found folder {MODEL_DIR}, but it is empty!")
        return
    
    # Using Juggernaut XL as requested by your output
    default_model = "juggernaut_xl.safetensors" if "juggernaut_xl.safetensors" in available_models else available_models[0]
    print(f"Using model: {default_model}")

    for filename in os.listdir(WORKFLOW_DIR):
        if filename.endswith(".json"):
            path = os.path.join(WORKFLOW_DIR, filename)
            try:
                with open(path, 'r') as f:
                    data = json.load(f)
                
                updated = False
                
                # Check if it's the standard ComfyUI dict format
                if isinstance(data, dict):
                    # Handle "Prompt" format (often used in API/saved workflows)
                    nodes = data
                    # If it's a web-save format, the nodes might be under a "nodes" key or just the dict itself
                    if "nodes" in data and isinstance(data["nodes"], list):
                        for node in data["nodes"]:
                            if isinstance(node, dict) and node.get("type") == "CheckpointLoaderSimple":
                                node.setdefault("widgets_values", [default_model])[0] = default_model
                                updated = True
                    else:
                        # Direct dictionary access (Node ID -> Node Data)
                        for node_id, node in data.items():
                            if isinstance(node, dict) and node.get("class_type") == "CheckpointLoaderSimple":
                                node["inputs"]["ckpt_name"] = default_model
                                updated = True
                
                if updated:
                    with open(path, 'w') as f:
                        json.dump(data, f, indent=4)
                    print(f"✅ Repaired: {filename}")
                else:
                    print(f"ℹ️ No CheckpointLoader found in: {filename}")
                    
            except Exception as e:
                print(f"⚠️ Could not process {filename}: {e}")

if __name__ == "__main__":
    repair_workflows()
