# Installation

## Requirements

- Git
- PowerShell
- Node.js (for optional plugins and Claude-Mem)
- GitHub Copilot CLI

## Recommended flow

1. Review `README.md` and `THIRD-PARTY-NOTICES.md`.
2. Run the verification script.
3. Use the manifest to confirm whether a skill is approved.
4. Restore only approved content with explicit authorization.

## Audit status

The current manifest has 52 entries with verified Apache-2.0 provenance and
conditional redistribution requirements, plus 1 local snapshot that remains
unverified. Because conditional entries require preservation of upstream
licenses and notices, the default restore workflow skips all 53 entries.
`-AllowLocalReference` is available only for local use and does not authorize
publication.

## Safe restore examples

```powershell
# Simulated review without modifying the system
.\setup.ps1 -Authorize -WhatIf

# Restore only approved skills
.\setup.ps1 -Authorize

# Local reference mode only; do not treat as public redistribution
.\restore.ps1 -Authorize -AllowLocalReference
```

## Local reference policy

`-AllowLocalReference` is a narrow exception for local-only installation. It must not be treated as permission to redistribute or publish third-party content.
