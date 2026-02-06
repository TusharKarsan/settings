# Requires -RunAsAdministrator

$wslIp = wsl hostname -I
$wslIp = $wslIp.Split()[0].Trim()

New-NetFirewallRule `
  -DisplayName "Qdrant MCP Bridge - TCP 8000" `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 8000 `
  -Action Allow `
  -Profile Any
  
New-NetFirewallRule `
  -DisplayName "Qdrant HTTP - TCP 6333" `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 6333 `
  -Action Allow `
  -Profile Any

New-NetFirewallRule `
  -DisplayName "Qdrant gRPC - TCP 6334" `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 6334 `
  -Action Allow `
  -Profile Any

# Anaything LLM
New-NetFirewallRule `
  -DisplayName "OpenWebUI - TCP 3000" `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 3000 `
  -Action Allow `
  -Profile Any

# Anaything LLM
New-NetFirewallRule `
  -DisplayName "Anaything LLM - TCP 3001" `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 3001 `
  -Action Allow `
  -Profile Any

# Anaything LLM
New-NetFirewallRule `
  -DisplayName "ComfyUI - TCP 8188" `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 8188 `
  -Action Allow `
  -Profile Any

# ------
# Tailscale
# ------

New-NetFirewallRule `
  -DisplayName "Tailscale Traffic (Android Fix)" `
  -Direction Inbound `
  -Protocol TCP `
  -RemoteAddress 100.64.0.0/10 `
  -Action Allow `
  -Profile Any

Set-NetIPInterface `
  -InterfaceAlias "vEthernet (WSL (Hyper-V firewall))" `
  -Forwarding Enabled
