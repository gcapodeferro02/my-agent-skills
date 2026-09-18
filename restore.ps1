$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillsRoot = Join-Path $root 'skills'
$githubSkills = Join-Path $HOME '.github\skills'
$claudeSkills = Join-Path $HOME '.claude\skills'

if (!(Test-Path $skillsRoot)) {
    throw "The skills directory was not found: $skillsRoot"
}

Get-ChildItem -LiteralPath $skillsRoot -Directory | ForEach-Object {
    $skill = Join-Path $_.FullName 'SKILL.md'
    if (!(Test-Path $skill)) {
        return
    }

    $name = $_.Name
    if ($name -like 'github-user-*') {
        $destination = Join-Path $githubSkills $name.Substring('github-user-'.Length)
    } elseif ($name -like 'claude-user-*') {
        $destination = Join-Path $claudeSkills $name.Substring('claude-user-'.Length)
    } else {
        $destination = Join-Path $githubSkills $name
    }

    New-Item -ItemType Directory -Path $destination -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $_.FullName '*') -Destination $destination -Recurse -Force
    Write-Output "Restored $name -> $destination"
}

Write-Output 'Restore complete. Restart your agent to reload skills.'
