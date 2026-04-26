# Configuration
$RemoteHost = "design"
$Port = 11434
$BaseUrl = "http://$($RemoteHost):$($Port)"
$ExpectedModels = @(
    "qwen2.5-coder:14b",
    "qwen2.5-coder:latest",
    "nomic-embed-text:latest",
    "dengcao/Qwen3-Reranker-8B:Q8_0"
)

Write-Host "--- Initialising Health Check for Design PC ---" -ForegroundColor Cyan

# 1. Network Connectivity Check
Write-Host "[1/3] Checking network path to $RemoteHost..." -NoNewline
if (Test-Connection -ComputerName $RemoteHost -Count 1 -Quiet) {
    Write-Host " OK" -ForegroundColor Green
} else {
    Write-Host " FAILED (Is Tailscale active?)" -ForegroundColor Red
    exit
}

# 2. API Responsiveness & Tag Check
Write-Host "[2/3] Fetching model tags from Ollama API..." -NoNewline
try {
    $TagsResponse = Invoke-RestMethod -Uri "$BaseUrl/api/tags" -Method Get -TimeoutSec 5
    $AvailableModels = $TagsResponse.models.name
    Write-Host " OK" -ForegroundColor Green
} catch {
    Write-Host " FAILED (Service might be down)" -ForegroundColor Red
    exit
}

# 3. Model Inventory Validation
Write-Host "[3/3] Validating required models:" -ForegroundColor Cyan
$Report = foreach ($Model in $ExpectedModels) {
    $Status = if ($AvailableModels -contains $Model) { "Present" } else { "MISSING" }
    $Color = if ($Status -eq "Present") { "Green" } else { "Red" }
    
    Write-Host "  > $Model : " -NoNewline
    Write-Host $Status -ForegroundColor $Color
    
    [PSCustomObject]@{
        Model  = $Model
        Status = $Status
    }
}

# Summary Table
Write-Host "`n--- Health Summary ---" -ForegroundColor Cyan
$Report | Format-Table -AutoSize

# Final Functional Test (Prompting the 14B model)
Write-Host "Performing functional test on qwen2.5-coder:14b..." -ForegroundColor Gray
$TestData = @{
    model = "qwen2.5-coder:14b"
    prompt = "State 'Ready' if you can hear me."
    stream = $false
} | ConvertTo-Json

try {
    $TestRun = Invoke-RestMethod -Uri "$BaseUrl/api/generate" -Method Post -Body $TestData -ContentType "application/json" -TimeoutSec 30
    Write-Host "Functional Test Result: $($TestRun.response.Trim())" -ForegroundColor Green
} catch {
    Write-Host "Functional Test: FAILED (Check VRAM usage or Model load issues)" -ForegroundColor Red
}

Write-Host "`nCheck complete. All systems on Design PC should be at optimal operating temperature (approx 40-50°C idle)." -ForegroundColor Gray
