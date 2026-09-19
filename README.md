# my-agent-skills

This repository is a portable catalog of agent skills and installation helpers for local setup and restore workflows.

It is designed to help users install and manage skills in a reproducible way, while keeping a conservative policy around provenance, licensing, and redistribution rights for third-party materials.

## What this project does

- catalogs skills and helper assets;
- records source, path, and SHA-256 provenance in `skills-manifest.json`;
- keeps a local restore path for approved skill content;
- verifies the manifest and integrity of packaged skill copies;
- blocks unsafe public redistribution by default until human review confirms the rights.

## Intended audience

This project is intended for users and operators who want to:

- restore a local skill catalog on a new machine;
- keep a reproducible skill environment;
- review provenance and licensing before public publication;
- manage local-only installs without assuming external content is freely redistributable.

## Supported platforms

### Windows
Supported.

### macOS
Not currently supported / experimental.

### Linux
Not currently supported / experimental.

## Repository structure

- `skills/` — bundled skill snapshots and related files;
- `skills-manifest.json` — per-skill provenance, source, hash, and redistribution metadata;
- `SKILL-SELECTION-POLICY.md` — the selection rules for skill usage;
- `setup.ps1` — restore and install entry point;
- `restore.ps1` — local restore workflow;
- `catalog/` — human-readable skill inventory and status table;
- `docs/` — architecture and installation guidance;
- `scripts/` — verification and health scripts.

## Third-party content

This repository may reference or redistribute skills created by third parties.

Third-party content is NOT automatically covered by this repository's license.

Each third-party component remains subject to its original license and terms.

See `THIRD-PARTY-NOTICES.md` and `skills-manifest.json`.

## Current audit posture

The manifest currently contains:

- 52 entries with verified upstream source and Apache-2.0 evidence, recorded as
  `allowed_with_conditions`;
- 1 local snapshot still marked `review_required` / `unknown`.

The 52 conditional entries remain blocked by default because redistribution
requires preserving the Apache license, copyright notices, and any
plugin-specific or dependency notices. The local snapshot has no reproducible
license evidence and must not be published as project-owned content.

See `third-party-notices/` for the preserved Apache license and notices.

## Installation

1. Review this README and the licensing notices.
2. Run the verification script before install or publication:

```powershell
.\scripts\verify.ps1
```

3. Use explicit authorization for local restore only:

```powershell
.\setup.ps1 -Authorize -WhatIf
.\setup.ps1 -Authorize
```

Conditional or unverified entries are intentionally skipped unless
`-AllowLocalReference` is explicitly requested. That switch enables local
reference use only; it does not grant permission to redistribute the content.

## Verification and update

The repository includes safety checks for manifest integrity, file presence, and provenance status:

```powershell
.\scripts\list.ps1
.\scripts\doctor.ps1
.\scripts\verify.ps1
.\scripts\update.ps1
```

## Contribution

Please do not contribute or publish content whose origin, license, or redistribution rights are unclear. If a skill or asset has not been explicitly reviewed, keep it out of public redistribution.

## Licensing

Original content in this repository is covered by `LICENSE` unless another file or notice states otherwise.

Third-party content remains subject to its original license and notice requirements.

## Security

This repository follows a conservative security posture for scripts, plugins, and external content. See `SECURITY.md`.

## Limitations

- some bundled skills may be local-only references, not public redistributable copies;
- not every third-party skill in the catalog has a confirmed redistribution license;
- installation and restore features do not override source license conditions.

## Support

This repository is maintained as a catalog and safety-first setup helper. Support is limited to provenance, restore, and installation health checks, not legal clearance for redistribution.
