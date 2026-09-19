[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$manifestPath = Join-Path $root 'skills-manifest.json'

if (!(Test-Path -LiteralPath $manifestPath)) {
    throw "Manifest not found: $manifestPath"
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
if ($null -eq $manifest) {
    throw 'Manifest is empty or invalid JSON.'
}

$passCount = 0
$warnCount = 0
$failCount = 0
$requiredEvidenceFields = @(
    'upstream_repository',
    'upstream_ref',
    'upstream_path',
    'evidence_url',
    'reviewed_at',
    'review_notes'
)
$validRedistribution = @('allowed', 'allowed_with_conditions', 'unknown', 'not_allowed')
$validProvenance = @('verified', 'review_required', 'unknown', 'not_allowed')
$validAttribution = @('yes', 'no', 'unknown')

Write-Output 'Skill verification'
Write-Output '------------------'

foreach ($entry in $manifest) {
    $safeName = [string]($entry.name)
    $bundledPath = [string]($entry.bundled_path)
    $resolvedPath = if ([string]::IsNullOrWhiteSpace($bundledPath)) { $root } else { Join-Path $root $bundledPath }
    $skillFile = Join-Path $resolvedPath 'SKILL.md'
    $licenseValue = [string]($entry.license)
    $status = [string]($entry.provenance_status)
    $redistribution = [string]($entry.redistribution)
    $attribution = [string]($entry.attribution_required)

    if (Test-Path -LiteralPath $skillFile) {
        $hash = (Get-FileHash -LiteralPath $skillFile -Algorithm SHA256).Hash.ToUpperInvariant()
        $expected = [string]($entry.sha256).ToUpperInvariant()

        if ($hash -eq $expected) {
            Write-Output "[PASS] $safeName"
            $passCount++
        } else {
            Write-Output "[FAIL] $safeName - hash mismatch"
            $failCount++
        }
    } else {
        Write-Output "[FAIL] $safeName - bundled file missing"
        $failCount++
    }

    if ($status -in @('review_required', 'unknown') -or $redistribution -in @('unknown', 'not_allowed', 'allowed_with_conditions')) {
        Write-Output "[WARN] $safeName - license/provenance not fully verified"
        $warnCount++
    }

    if ([string]::IsNullOrWhiteSpace($licenseValue) -or $licenseValue -eq 'UNVERIFIED') {
        Write-Output "[WARN] $safeName - license value missing or unverified"
        $warnCount++
    }

    foreach ($field in $requiredEvidenceFields) {
        if ($null -eq $entry.PSObject.Properties[$field]) {
            Write-Output "[FAIL] $safeName - missing evidence field: $field"
            $failCount++
        }
    }

    if ($redistribution -notin $validRedistribution) {
        Write-Output "[FAIL] $safeName - invalid redistribution status: $redistribution"
        $failCount++
    }

    if ($status -notin $validProvenance) {
        Write-Output "[FAIL] $safeName - invalid provenance status: $status"
        $failCount++
    }

    if ($attribution -notin $validAttribution) {
        Write-Output "[FAIL] $safeName - invalid attribution status: $attribution"
        $failCount++
    }

    $approved = $redistribution -eq 'allowed' -and $status -eq 'verified'
    if ($approved) {
        $approvalFields = @('source_url', 'license_url', 'evidence_url', 'reviewed_at', 'upstream_repository', 'upstream_ref', 'upstream_path')
        foreach ($field in $approvalFields) {
            if ([string]::IsNullOrWhiteSpace([string]$entry.$field) -or [string]$entry.$field -eq 'pending') {
                Write-Output "[FAIL] $safeName - approved entry has incomplete $field"
                $failCount++
            }
        }
    }

    if ($redistribution -eq 'allowed_with_conditions' -and $status -eq 'verified') {
        if ([string]::IsNullOrWhiteSpace([string]$entry.review_notes)) {
            Write-Output "[FAIL] $safeName - conditional approval requires review_notes"
            $failCount++
        } else {
            Write-Output "[WARN] $safeName - redistribution is conditional and remains blocked by default"
            $warnCount++
        }
    }

    if ([string]::IsNullOrWhiteSpace($bundledPath) -or !(Test-Path -LiteralPath $resolvedPath)) {
        Write-Output "[FAIL] $safeName - bundled_path invalid or missing"
        $failCount++
    }
}

Write-Output ''
Write-Output "Summary: $passCount passed, $warnCount warnings, $failCount failed"
if ($failCount -gt 0) { exit 1 }
