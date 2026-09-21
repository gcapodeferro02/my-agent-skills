# Changelog

All notable changes to this repository are documented here.

## 2026-09-18

### Governance and licensing audit

- Added contribution rules covering provenance, licensing, pull requests, and
  third-party content.
- Documented the current audit posture: 52 Apache-2.0 snapshots are
  `REDISTRIBUTE_WITH_ATTRIBUTION`, while one local snapshot remains
  `REVIEW_REQUIRED`.
- Kept conditional and unverified content blocked by default.
- Added explicit publication gates requiring human review before removals,
  approvals, commits, or final pull requests.
- Continued preserving the Apache-2.0 license, upstream notices, and source
  evidence under `third-party-notices/`.

## 2026-09-17

### Provenance hardening

- Added manifest evidence fields and immutable upstream references.
- Added verification and diagnostic scripts.
- Hardened restore and setup workflows against unverified redistribution.
- Added project licensing and third-party notice documentation.
