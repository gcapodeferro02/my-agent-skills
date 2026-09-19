[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$Authorize,
    [switch]$InternalAuthorized,
    [switch]$AllowLocalReference
)

$ErrorActionPreference = 'Stop'

if (!$Authorize -and !$InternalAuthorized) {
    Write-Output 'Authorization required. Nothing was changed.'
    Write-Output 'Run .\configure.ps1 -Authorize after reviewing the manual.'
    exit 1
}

if (!$InternalAuthorized) {
    $phrase = Read-Host 'Digite exatamente: I AUTHORIZE SKILL RESTORE'
    if ($phrase -cne 'I AUTHORIZE SKILL RESTORE') {
        Write-Output 'Autorização não confirmada. Nada foi alterado.'
        exit 1
    }
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillsRoot = Join-Path $root 'skills'
$manifestPath = Join-Path $root 'skills-manifest.json'
$githubSkills = Join-Path $HOME '.github\skills'
$claudeSkills = Join-Path $HOME '.claude\skills'

if (!(Test-Path $skillsRoot)) {
    throw "The skills directory was not found: $skillsRoot"
}

$manifest = @()
if (Test-Path $manifestPath) {
    $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
}

function Test-BlockedSkill {
    param(
        [object]$Entry
    )

    if ($null -eq $Entry) {
        return $true
    }

    $redistribution = [string]($Entry.redistribution)
    $status = [string]($Entry.provenance_status)
    return $redistribution -ne 'allowed' -or $status -ne 'verified'
}

Get-ChildItem -LiteralPath $skillsRoot -Directory | ForEach-Object {
    $skill = Join-Path $_.FullName 'SKILL.md'
    if (!(Test-Path $skill)) {
        return
    }

    $name = $_.Name
    $entry = @($manifest | Where-Object { $_.name -eq $name }) | Select-Object -First 1
    $blocked = Test-BlockedSkill -Entry $entry

    if ($blocked -and !$AllowLocalReference) {
        Write-Warning "Skipping blocked skill: $name (manifest is not verified for unrestricted redistribution)"
        return
    }

    if ($name -like 'github-user-*') {
        $destination = Join-Path $githubSkills $name.Substring('github-user-'.Length)
    } elseif ($name -like 'claude-user-*') {
        $destination = Join-Path $claudeSkills $name.Substring('claude-user-'.Length)
    } else {
        $destination = Join-Path $githubSkills $name
    }

    if ($PSCmdlet.ShouldProcess($destination, "Restore skill $name")) {
        New-Item -ItemType Directory -Path $destination -Force | Out-Null
        Copy-Item -LiteralPath (Join-Path $_.FullName '*') -Destination $destination -Recurse -Force
        Write-Output "Restored $name -> $destination"
    }
}

Write-Output 'Restore complete. Restart your agent to reload skills.'
