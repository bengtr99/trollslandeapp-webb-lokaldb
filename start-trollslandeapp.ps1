# Launcher for the Trollslandor app (production build, instant start).
# Serves the latest existing production build via "vite preview" without
# rebuilding. Rebuild manually with "Bygg om Trollslandor" after code changes.
# Close this window to stop the app.
$ErrorActionPreference = 'SilentlyContinue'
$projectDir = $PSScriptRoot
$url = 'http://localhost:4173/'

Set-Location $projectDir
# Make sure node/npm are found even if launched with a minimal environment.
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

function Test-AppUp {
    try { return (Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 2).StatusCode -eq 200 } catch { return $false }
}

# If the app is already running, just open a new browser tab and exit.
if (Test-AppUp) {
    Start-Process $url
    exit 0
}

# Only build if there is no existing production build yet (first run / clean checkout).
if (-not (Test-Path (Join-Path $projectDir 'dist\index.html'))) {
    Write-Host 'Ingen build hittades - bygger en gang...'
    npm run build
    if (-not (Test-Path (Join-Path $projectDir 'dist\index.html'))) {
        Write-Host 'Bygget misslyckades.'
        Read-Host 'Tryck Enter for att avsluta'
        exit 1
    }
}

# Open the browser as soon as the preview server answers (hidden helper process).
$opener = @'
for ($i = 0; $i -lt 60; $i++) {
    try { if ((Invoke-WebRequest -Uri "http://localhost:4173/" -UseBasicParsing -TimeoutSec 2).StatusCode -eq 200) { Start-Process "http://localhost:4173/"; break } } catch { Start-Sleep -Milliseconds 300 }
}
'@
Start-Process powershell -WindowStyle Hidden -ArgumentList '-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', $opener

Write-Host 'Trollslandor-appen kor (produktionsversion).'
Write-Host 'Stang detta fonster for att stanga appen.'
npm run preview -- --port 4173 --strictPort
