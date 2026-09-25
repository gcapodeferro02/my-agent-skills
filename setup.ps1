[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$Authorize,
    [switch]$SkipPlugins,
    [switch]$SkipClaudeMem,
    [switch]$AllowLocalReference
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$results = New-Object System.Collections.Generic.List[string]

if (!$Authorize) {
    Write-Output 'Authorization required. Nothing was changed.'
    Write-Output 'Run .\setup.ps1 -Authorize after reviewing RECONFIGURATION-MANUAL.md.'
    exit 1
}

$phrase = 'I AUTHORIZE RECONFIGURATION'
if ($phrase -cne 'I AUTHORIZE RECONFIGURATION') {
    Write-Output 'Autorização não confirmada. Nada foi alterado.'
    exit 1
}

if ($WhatIfPreference) {
    Write-Output 'WhatIf: would restore only approved skills, install the skill-selection policy,'
    if (!$SkipPlugins) {
        Write-Output 'WhatIf: would install Superpowers and Impeccable.'
    }
    if (!$SkipClaudeMem) {
        Write-Output 'WhatIf: would install and start Claude-Mem.'
    }
    exit 0
}

function Invoke-SetupStep {
    param(
        [string]$Name,
        [scriptblock]$Action
    )

    Write-Output "==> $Name"
    try {
        & $Action
        $results.Add("PASS: $Name") | Out-Null
    } catch {
        $results.Add("FAIL: $Name - $($_.Exception.Message)") | Out-Null
        Write-Warning $_.Exception.Message
    }
}

Invoke-SetupStep 'Verify manifest and block unapproved content' {
    $manifestPath = Join-Path $root 'skills-manifest.json'
    if (!(Test-Path -LiteralPath $manifestPath)) {
        throw "Manifest not found: $manifestPath"
    }
    $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    $blocked = @($manifest | Where-Object { $_.redistribution -ne 'allowed' -or $_.provenance_status -ne 'verified' })
    if ($blocked.Count -gt 0 -and !$AllowLocalReference) {
        Write-Output "Blocked-by-default skills: $($blocked.Count)"
        $blocked | ForEach-Object {
            Write-Output ("- {0}: redistribution={1}; provenance={2}" -f $_.name, $_.redistribution, $_.provenance_status)
        }
    }
}

Invoke-SetupStep 'Restore cataloged skills' {
    if ($AllowLocalReference) {
        & (Join-Path $root 'restore.ps1') -InternalAuthorized -AllowLocalReference
    } else {
        & (Join-Path $root 'restore.ps1') -InternalAuthorized
    }
}

Invoke-SetupStep 'Install skill-selection policy' {
    $instructionsDir = Join-Path $HOME 'Desktop\.github'
    $instructions = Join-Path $instructionsDir 'copilot-instructions.md'
    $policy = @"
## Skill catalog selection

Before starting every new user request, scan the local skill catalog and select
the most relevant available skill or combination of skills. Read and follow
the selected skill instructions before taking action, including before asking
clarifying questions or exploring files. If no skill applies, proceed normally.
Do not invoke unrelated skills merely because they exist.

The portable catalog is maintained at:

$HOME\my-agent-skills

## Licensing rule

Skill selection/execution and redistribution rights are independent.
A skill may be usable by an agent while still being prohibited from redistribution.
The repository must never copy or redistribute a third-party skill unless its
redistribution rights have been verified.
"@
    New-Item -ItemType Directory -Path $instructionsDir -Force | Out-Null
    if (!(Test-Path -LiteralPath $instructions)) {
        Set-Content -LiteralPath $instructions -Value $policy -Encoding UTF8
    } elseif (!(Select-String -LiteralPath $instructions -Pattern '## Licensing rule' -Quiet)) {
        Add-Content -LiteralPath $instructions -Value "`r`n$policy"
    }
}

if (!$SkipPlugins) {
    Invoke-SetupStep 'Install Superpowers' {
        if (!(Get-Command copilot -ErrorAction SilentlyContinue)) {
            throw 'Copilot CLI was not found.'
        }
        & copilot plugin marketplace add obra/superpowers-marketplace
        & copilot plugin install superpowers@superpowers-marketplace
    }

    Invoke-SetupStep 'Install Impeccable' {
        if (!(Get-Command npx.cmd -ErrorAction SilentlyContinue)) {
            throw 'Node.js/npm was not found.'
        }
        & npx.cmd --yes impeccable@latest install --providers=github --scope=global --yes
    }
}

if (!$SkipClaudeMem) {
    Invoke-SetupStep 'Install Claude-Mem for Copilot CLI' {
        if (!(Get-Command npx.cmd -ErrorAction SilentlyContinue)) {
            throw 'Node.js/npm was not found.'
        }
        & npx.cmd --yes claude-mem@latest install --provider claude --ide copilot-cli
        & npx.cmd --yes claude-mem@latest start
    }
}

Write-Output ''
Write-Output 'Setup summary:'
$results | ForEach-Object { Write-Output $_ }
Write-Output ''
Write-Output 'Restart the agent after setup.'
