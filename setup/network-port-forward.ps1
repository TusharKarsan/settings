# Requires -RunAsAdministrator

$wslIp = wsl hostname -I
$wslIp = $wslIp.Split()[0].Trim()

# ------
# Remove
# ------

# Ollama
netsh interface portproxy delete v4tov4 `
  listenport=11434 listenaddress=0.0.0.0

# Qdrant HTTP
netsh interface portproxy delete v4tov4 `
  listenport=6333 listenaddress=0.0.0.0

# Qdrant gRPC
netsh interface portproxy delete v4tov4 `
  listenport=6334 listenaddress=0.0.0.0

# Qdrant MCP Bridge
netsh interface portproxy delete v4tov4 `
  listenport=8000 listenaddress=0.0.0.0
  
# OpenWebUI
netsh interface portproxy delete v4tov4 `
  listenport=3000 listenaddress=0.0.0.0

# Anaything LLM
netsh interface portproxy delete v4tov4 `
  listenport=3001 listenaddress=0.0.0.0

# ComfyUI
netsh interface portproxy delete v4tov4 `
  listenport=8188 listenaddress=0.0.0.0

# OpenSearch
netsh interface portproxy delete v4tov4 `
  listenport=9200 listenaddress=0.0.0.0

# OpenSearch Dashboards
netsh interface portproxy delete v4tov4 `
  listenport=5601 listenaddress=0.0.0.0

# -----
# Allow
# -----

# Ollama
netsh interface portproxy add v4tov4 `
  listenport=11434 listenaddress=0.0.0.0 `
  connectport=11434 connectaddress=$wslIp

# Qdrant HTTP
netsh interface portproxy add v4tov4 `
  listenport=6333 listenaddress=0.0.0.0 `
  connectport=6333 connectaddress=$wslIp

# Qdrant gRPC
netsh interface portproxy add v4tov4 `
  listenport=6334 listenaddress=0.0.0.0 `
  connectport=6334 connectaddress=$wslIp

# Qdrant MCP Bridge
netsh interface portproxy add v4tov4 `
  listenport=8000 listenaddress=0.0.0.0 `
  connectport=8000 connectaddress=$wslIp

# OpenWebUI
netsh interface portproxy add v4tov4 `
  listenport=3000 listenaddress=0.0.0.0 `
  connectport=3000 connectaddress=$wslIp
  
# Anaything LLM
netsh interface portproxy add v4tov4 `
  listenport=3001 listenaddress=0.0.0.0 `
  connectport=3001 connectaddress=$wslIp

# ComfyUI
netsh interface portproxy add v4tov4 `
  listenport=8188 listenaddress=0.0.0.0 `
  connectport=8188 connectaddress=$wslIp

# OpenSearch
netsh interface portproxy add v4tov4 `
  listenport=9200 listenaddress=0.0.0.0 `
  connectport=9200 connectaddress=$wslIp

# OpenSearch Dashboards
netsh interface portproxy add v4tov4 `
  listenport=5601 listenaddress=0.0.0.0 `
  connectport=5601 connectaddress=$wslIp
