# My Agent Skills

Portable backup of the skills available on this machine.

## Contents

- `skills/` contains each skill and its auxiliary files.
- `skills-manifest.json` records the source category and SHA-256 for each `SKILL.md`.
- `SKILL-SELECTION-POLICY.md` defines the required skill-selection workflow.
- `RECONFIGURATION-MANUAL.md` documents the authorized recovery workflow.
- `configure.ps1` runs the guarded recovery workflow on Windows.
- `restore.ps1` restores the bundle to the standard user-level skill locations on Windows.

Managed plugin skills are stored as snapshots. Update this repository when the
source plugins change. Runtime data, caches, logs, databases, and credentials
are intentionally excluded.

## Restore

From the repository root in PowerShell:

```powershell
.\configure.ps1 -Authorize
```

The script asks for a second confirmation before making changes. Restart the relevant agent after restoring. Skills from managed plugins may
also require reinstalling the original plugin so its commands and hooks are
registered.
