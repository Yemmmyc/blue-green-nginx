$envFile = ".env"
$content = Get-Content $envFile
$activePool = ($content | Where-Object { $_ -match "ACTIVE_POOL" }) -split "=" | Select-Object -Last 1

if ($activePool -eq "blue") {
    $newPool = "green"
} else {
    $newPool = "blue"
}

# Update .env file
(Get-Content $envFile) -replace "ACTIVE_POOL=.*", "ACTIVE_POOL=$newPool" | Set-Content $envFile

Write-Host "🔄 Switching traffic to $newPool environment..."
docker compose up -d nginx

Write-Host "✅ Deployment switched! Active pool: $newPool"
Invoke-RestMethod -Uri "http://localhost:8080/version"
