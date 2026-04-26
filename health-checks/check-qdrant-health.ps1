# Configuration
$RemoteHost = "design"
$Port = 6333
$BaseUrl = "http://$($RemoteHost):$($Port)"
$ProjectCollection = "email-embeddings" # Update this to your actual collection name

Write-Host "--- Initialising Qdrant Health Check: Design PC ---" -ForegroundColor Cyan

# 1. API Health Endpoint
Write-Host "[1/2] Checking Qdrant Service Health..." -NoNewline
try {
    # Qdrant root returns basic info including version
    $Info = Invoke-RestMethod -Uri "$BaseUrl/" -Method Get -TimeoutSec 5
    Write-Host " OK (Version: $($Info.version))" -ForegroundColor Green
} catch {
    Write-Host " FAILED" -ForegroundColor Red
    Write-Host "Error: Could not reach Qdrant at $BaseUrl. Is 'networkingMode=mirrored' active?" -ForegroundColor Gray
    exit
}

# 2. Collection Validation
Write-Host "[2/2] Checking Collections..." -ForegroundColor Cyan
try {
    $Collections = Invoke-RestMethod -Uri "$BaseUrl/collections" -Method Get
    $Names = $Collections.result.collections.name
    
    foreach ($Name in $Names) {
        $Marker = if ($Name -eq $ProjectCollection) { "[PROJECT TARGET]" } else { "" }
        Write-Host "  > Found Collection: $Name $Marker" -ForegroundColor Yellow
    }

    if ($Names -contains $ProjectCollection) {
        Write-Host "`nSUCCESS: '$ProjectCollection' is ready for querying." -ForegroundColor Green
    } else {
        Write-Host "`nWARNING: Project collection '$ProjectCollection' not found." -ForegroundColor Red
    }
} catch {
    Write-Host " FAILED to retrieve collections." -ForegroundColor Red
}

Write-Host "`nTelemetry: Design PC temperature and VRAM should be monitored if performing bulk indexing." -ForegroundColor Gray
