# My Agent Skills

Portable backup of the skills available on this machine.

## Contents

- `skills/` contains each skill and its auxiliary files.
- `skills-manifest.json` records the source category and SHA-256 for each `SKILL.md`.
- `restore.ps1` restores the bundle to the standard user-level skill locations on Windows.

Managed plugin skills are stored as snapshots. Update this repository when the
source plugins change. Runtime data, caches, logs, databases, and credentials
are intentionally excluded.

## Restore

From the repository root in PowerShell:

```powershell
.\restore.ps1
```

Restart the relevant agent after restoring. Skills from managed plugins may
also require reinstalling the original plugin so its commands and hooks are
registered.
