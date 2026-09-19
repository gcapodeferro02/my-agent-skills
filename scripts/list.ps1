[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$manifestPath = Join-Path $root 'skills-manifest.json'

if (!(Test-Path -LiteralPath $manifestPath)) {
    throw "Manifest not found: $manifestPath"
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
Write-Output 'Skills in manifest:'
foreach ($entry in @($manifest)) {
    $status = [string]($entry.provenance_status)
    $redistribution = [string]($entry.redistribution)
    Write-Output ("- {0} | provenance={1} | redistribution={2}" -f [string]($entry.name), $status, $redistribution)
}
