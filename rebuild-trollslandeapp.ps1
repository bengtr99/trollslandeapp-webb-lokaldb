# Rebuilds the Trollslandor production build after code changes.
# Run this (via the "Bygg om Trollslandor" desktop shortcut) whenever the code
# has changed; then start the app again with the normal shortcut.
$ErrorActionPreference = 'SilentlyContinue'
$projectDir = $PSScriptRoot

Set-Location $projectDir
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

# Stop a running app so the next start serves the freshly built version.
Get-NetTCPConnection -LocalPort 4173 -State Listen -ErrorAction SilentlyContinue |
    ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }

Write-Host 'Bygger om Trollslandor-appen (produktionsversion)...'
Write-Host ''
npm run build

if (Test-Path (Join-Path $projectDir 'dist\index.html')) {
    Write-Host ''
    Write-Host 'KLART! Ny version byggd. Starta appen via skrivbordsikonen "Trollslandor".'
} else {
    Write-Host ''
    Write-Host 'Bygget MISSLYCKADES - se felmeddelandet ovan.'
}
Read-Host 'Tryck Enter for att stanga'
