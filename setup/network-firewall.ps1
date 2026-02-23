# Requires -RunAsAdministrator

# ------
# Clean up old rules
# ------

$ports = 11434, 8000, 6333, 6334, 3000, 3001, 8188

Write-Host "Collecting rules with matching ports..."

$rules = Get-NetFirewallRule |
    ForEach-Object {
        $rule = $_
        $filters = Get-NetFirewallPortFilter -AssociatedNetFirewallRule $rule

        # Match any filter that has a LocalPort AND is in our list
        if ($filters.LocalPort -ne $null -and ($filters.LocalPort | ForEach-Object { $_ -in $ports } | Where-Object { $_ })) {
            $rule
        }
    } | Sort-Object -Unique

Write-Host "`nRules that will be removed:"
$rules | Select-Object DisplayName, Direction, Action, Enabled

Write-Host "`nRemoving rules..."
$rules | Remove-NetFirewallRule

Write-Host "Done."

# ------
# Set up new rules
# ------

$wslIp = wsl hostname -I
$wslIp = $wslIp.Split()[0].Trim()

New-NetFirewallRule `
  -DisplayName "Ollama TCP 11434" `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 11434 `
  -Action Allow `
  -Profile Any

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

$ruleName = "Tailscale Traffic (Android Fix)"

# Check if the rule exists
$existing = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue

# If it exists, remove it
if ($existing) {
    Remove-NetFirewallRule -DisplayName $ruleName
}

# Create the rule fresh
New-NetFirewallRule `
  -DisplayName $ruleName `
  -Direction Inbound `
  -Protocol TCP `
  -RemoteAddress 100.64.0.0/10 `
  -Action Allow `
  -Profile Any

Get-NetFirewallRule -DisplayName $ruleName

Set-NetIPInterface `
  -InterfaceAlias "vEthernet (WSL (Hyper-V firewall))" `
  -Forwarding Enabled

Get-NetIPInterface `
  -InterfaceAlias "vEthernet (WSL (Hyper-V firewall))" `
  -AddressFamily IPv4 | `
  Select-Object InterfaceAlias, AddressFamily, Forwarding

# ------
# List Them
# ------

Write-Host "Getting new rules..."
# Get the actual rule objects (deduped)
$rules = Get-NetFirewallRule |
  ForEach-Object {
    $rule = $_
    Get-NetFirewallPortFilter -AssociatedNetFirewallRule $rule |
      Where-Object { $_.LocalPort -in $ports } |
      ForEach-Object { $rule }
  } | Sort-Object -Unique

# Show what will be removed
$rules | Select-Object DisplayName, Direction, Action
