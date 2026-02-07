$Url = "http://design:6333/collections/email-embeddings"

$Body = @{
    vectors = @{
        size = 768
        distance = "Cosine"
    }
} | ConvertTo-Json

Write-Host "Creating 'email-embeddings' collection on Design PC..." -ForegroundColor Cyan

try {
    Invoke-RestMethod -Uri $Url -Method Put -Body $Body -ContentType "application/json"
    Write-Host "Successfully created collection!" -ForegroundColor Green
} catch {
    Write-Host "Failed to create collection. Check if Qdrant is reachable." -ForegroundColor Red
}
