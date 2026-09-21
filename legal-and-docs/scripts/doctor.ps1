[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

Write-Output 'Skill environment diagnostic'
Write-Output '---------------------------'

$checks = @(
    @{ Name = 'skills directory'; Path = (Join-Path $root 'skills'); Expected = $true },
    @{ Name = 'manifest'; Path = (Join-Path $root 'skills-manifest.json'); Expected = $true },
    @{ Name = 'README'; Path = (Join-Path $root 'README.md'); Expected = $true },
    @{ Name = 'third-party notices'; Path = (Join-Path $root 'THIRD-PARTY-NOTICES.md'); Expected = $true },
    @{ Name = 'security policy'; Path = (Join-Path $root 'SECURITY.md'); Expected = $true },
    @{ Name = 'git ignore'; Path = (Join-Path $root '.gitignore'); Expected = $true }
)

foreach ($check in $checks) {
    $exists = Test-Path -LiteralPath $check.Path
    $label = if ($exists) { 'OK' } else { 'MISSING' }
    Write-Output ("[{0}] {1} -> {2}" -f $label, $check.Name, $check.Path)
}

$manifestPath = Join-Path $root 'skills-manifest.json'
if (Test-Path -LiteralPath $manifestPath) {
    $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    $unknown = @($manifest | Where-Object { $_.redistribution -in @('unknown','not_allowed') -or $_.provenance_status -in @('unknown','review_required') }).Count
    Write-Output ("Unverified items: {0}" -f $unknown)
}
