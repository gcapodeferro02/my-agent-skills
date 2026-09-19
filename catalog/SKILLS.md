# Skill catalog

This catalog records the current posture of bundled skills from a licensing and provenance standpoint.

Current count: 52 entries are `VERIFIED` with `allowed_with_conditions`
redistribution, and 1 local snapshot is `REVIEW_REQUIRED` with `unknown`
redistribution. Conditional entries remain blocked by default.

| Skill | Category | Origin | License | Redistribution | Status |
|---|---|---|---|---|---|
| `skills/*` | Third-party snapshots | Claude marketplace / external sources | Unverified / review required | `unknown` / `not_allowed` until verified | `REVIEW_REQUIRED` |
| `skills/claude-user-use-findskill` | Local reference | User-local override | Unverified | `unknown` | `REVIEW_REQUIRED` |

## Status meanings

- `VERIFIED`: upstream source, license, evidence URL, and redistribution
  permission are recorded in `skills-manifest.json`.
- `ALLOWED_WITH_CONDITIONS`: evidence exists, but the recorded conditions must
  be satisfied before any redistribution.
- `REVIEW_REQUIRED` / `UNKNOWN`: evidence is incomplete; keep the snapshot
  blocked and use local-reference mode only when necessary.
- `NOT_ALLOWED`: the available terms do not permit redistribution.

Do not present any skill with `UNKNOWN`, `REVIEW_REQUIRED`, or `NOT_ALLOWED`
as redistributable without explicit human approval and recorded evidence.
