[CmdletBinding(SupportsShouldProcess)]
param()

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

Write-Output 'Checking repository state...'
if (Get-Command git -ErrorAction SilentlyContinue) {
    & git -C $root status --short
}

$manifestPath = Join-Path $root 'skills-manifest.json'
if (Test-Path -LiteralPath $manifestPath) {
    $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    $total = @($manifest).Count
    $blocked = @($manifest | Where-Object { $_.redistribution -in @('unknown','not_allowed') -or $_.provenance_status -in @('unknown','review_required') }).Count
    Write-Output ("Manifest entries: {0}; blocked by default: {1}" -f $total, $blocked)
}

Write-Output 'Review local changes before applying update.'
Write-Output 'Use Git to inspect and commit any approved modifications.'
