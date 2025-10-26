# rollback.ps1
$envFile = ".env"
$content = Get-Content $envFile
$activePool = ($content | Where-Object { $_ -match "ACTIVE_POOL" }) -split "=" | Select-Object -Last 1

if ($activePool -eq "blue") {
    $rollbackPool = "green"
} else {
    $rollbackPool = "blue"
}

Write-Host "⚠️ Rolling back to $rollbackPool environment..."

# Update .env file
(Get-Content $envFile) -replace "ACTIVE_POOL=.*", "ACTIVE_POOL=$rollbackPool" | Set-Content $envFile

# Recreate Nginx to point back to the stable pool
docker compose up -d nginx

Write-Host "✅ Rollback complete! Active pool: $rollbackPool"
Invoke-RestMethod -Uri "http://localhost:8080/version"
