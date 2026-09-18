[CmdletBinding()]
param(
    [switch]$Authorize
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$restore = Join-Path $root 'restore.ps1'

if (!$Authorize) {
    Write-Output 'Authorization required. Nothing was changed.'
    Write-Output 'After reviewing RECONFIGURATION-MANUAL.md, run:'
    Write-Output '.\configure.ps1 -Authorize'
    exit 1
}

$phrase = Read-Host 'Type exactly: I AUTHORIZE RECONFIGURATION'
if ($phrase -cne 'I AUTHORIZE RECONFIGURATION') {
    Write-Output 'Authorization not confirmed. Nothing was changed.'
    exit 1
}

if (!(Test-Path -LiteralPath $restore)) {
    throw "Restore script not found: $restore"
}

Write-Output 'Authorized scope: restore cataloged skills only.'
Write-Output 'Plugins, MCP servers, workers, credentials, logs, and caches are not modified.'
& $restore -Authorize

Write-Output ''
Write-Output 'Catalog restoration complete.'
Write-Output 'Review RECONFIGURATION-MANUAL.md for manual plugin and integration steps.'
