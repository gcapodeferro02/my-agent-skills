# Architecture

This repository is a portable skill catalog and installation helper. Its purpose is to collect skills, document provenance, and provide safe local restore/install workflows without assuming that bundled third-party content is redistributable by default.

## Components

- `skills/` — bundled skills and auxiliary files;
- `skills-manifest.json` — original source, bundled path, hash, and provenance metadata;
- `setup.ps1` — installation entry point;
- `restore.ps1` — restore approved skills to user-local directories;
- `scripts/` — verification, listing, diagnosis, and update scripts;
- `catalog/` — human-readable taxonomy and status reports;
- `docs/` — repository documentation.

## Safety model

The repository uses a conservative policy:

- only approved entries may be restored for public redistribution;
- unverified or blocked entries are skipped by default;
- local-only reference mode is allowed only when explicitly requested and not treated as redistribution;
- installation behavior is bound to the manifest and hash checks.

## Risk boundaries

This catalog is not a license cleanup system. It is a provenance ledger and restore gate. Any content whose licensing or redistribution rights are not clearly documented remains blocked from default installation and redistribution.
