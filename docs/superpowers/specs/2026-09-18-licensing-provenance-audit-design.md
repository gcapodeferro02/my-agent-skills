# Licensing and Provenance Audit Design

## Goal

Make the skill catalog safe for public maintenance and publication without
assuming that a GitHub snapshot is licensed for redistribution. Every bundled
skill must either have recorded evidence for its source, license, and
redistribution terms or remain blocked by default.

## Scope

- Audit the 53 manifest entries against their identifiable upstream sources.
- Record only evidence that can be tied to a stable upstream URL and source
  path.
- Preserve unverified snapshots locally while keeping them blocked from normal
  restore and publication workflows.
- Add or preserve required third-party notices and license references.
- Make verification fail when an entry claims approval without the metadata
  needed to support that claim.
- Validate the final tree, commit the changes, and push to `origin/main`.

This does not provide legal advice or certify that any license is compatible
with every intended use. Ambiguous or incomplete evidence remains
`review_required` and is not treated as redistributable.

## Design

### Provenance ledger

`skills-manifest.json` remains the source of truth. Each entry records:

- upstream repository and source URL;
- original source path and bundled path;
- immutable snapshot hash;
- license identifier and license URL;
- copyright/attribution text;
- redistribution status;
- provenance review status;
- evidence URL or note sufficient for a human reviewer to reproduce the check.

The audit may promote an entry only when the upstream source and licensing
evidence are explicit. It must not infer a license from repository visibility,
file content, or a platform default.

### Conservative publication policy

An entry is approved only when its metadata says that provenance is verified
and redistribution is allowed, with any attribution requirements recorded.
Entries with unknown, pending, review-required, or conditional values remain
blocked unless the caller explicitly requests local-reference mode.

### Notices

Project-owned documentation remains under the repository license. Bundled
third-party material remains subject to its own terms. If an upstream source
requires a notice or license text, the repository keeps a corresponding notice
and points to the source rather than rewriting the upstream terms.

### Verification

The verification script checks JSON validity, path existence, snapshot hashes,
required provenance fields, and consistency between approval status and
evidence. It reports unverified entries as warnings only when they are
conservatively blocked; it fails for missing files, hash mismatches, or
unsupported approval claims.

### Restore and release behavior

`restore.ps1` and `setup.ps1` continue to block unverified content by default.
`-AllowLocalReference` is an explicit local-use escape hatch and is not a
redistribution approval. No script may silently convert local-reference
content into approved public content.

## Data flow

1. Read the manifest and derive the upstream candidate for each snapshot.
2. Inspect upstream repository metadata, license files, notices, and source
   paths.
3. Write evidence-backed metadata for approved entries; leave ambiguous
   entries blocked.
4. Verify hashes and metadata invariants.
5. Review the diff and publish the change through the configured Git remote.

## Error handling

- Missing upstream evidence leaves the entry blocked and records the reason.
- Missing bundled files or hash mismatches fail verification.
- An approval value without a license URL, source URL, or provenance evidence
  fails verification rather than falling back to a permissive default.
- Network or GitHub lookup failures do not produce success-shaped metadata.

## Validation

- Run `scripts\verify.ps1`.
- Run targeted checks for manifest parsing and blocked restore behavior.
- Inspect `git diff --check` and the final status.
- Commit with a descriptive message and the required Copilot co-author trailer.
- Push to `origin/main` only after validation succeeds.

