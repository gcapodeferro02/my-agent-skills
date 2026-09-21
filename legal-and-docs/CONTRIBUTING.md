# Contributing

Contributions are welcome when they preserve the repository's provenance,
licensing, and security requirements.

## Before contributing

- Read `README.md`, `SECURITY.md`, and `THIRD-PARTY-NOTICES.md`.
- Do not add copied skills, plugin content, documentation, code, or assets
  without a reproducible source, license, and redistribution assessment.
- Treat public availability as insufficient evidence of redistribution rights.
- Keep third-party content separate from original repository content.

## Adding or updating a skill

Every bundled skill must have a corresponding entry in
`skills-manifest.json` containing:

- source and upstream repository;
- immutable upstream ref;
- upstream path and source URL;
- license and license URL;
- copyright and attribution requirements;
- redistribution status;
- provenance status;
- evidence URL, review date, and factual review notes;
- SHA-256 integrity hash.

Use `REVIEW_REQUIRED` or `unknown` when any material fact cannot be verified.
Do not mark content as approved by inference.

## Pull requests

1. Explain the purpose and scope of the change.
2. Identify every added, removed, or modified skill and manifest record.
3. Include licensing and provenance evidence for new third-party content.
4. Run the repository verification script:

   ```powershell
   .\scripts\verify.ps1
   ```

5. Include the verification result in the pull request description.
6. Do not publish or redistribute content that remains blocked by policy.

Pull requests that change third-party content require human review before
merge. Changes that remove or approve a previously blocked skill require an
explicit licensing decision in the pull request.

## Style and maintenance

- Follow the existing PowerShell and Markdown conventions.
- Prefer small, focused changes.
- Preserve upstream license and notice files.
- Do not commit secrets, credentials, generated personal data, or local
  machine state.
- Update `CHANGELOG.md` for user-visible governance, policy, or workflow
  changes.

## Reporting problems

Use an issue for reproducible bugs, missing provenance, incorrect license
metadata, hash mismatches, unsafe restore behavior, or documentation errors.

Do not include secrets, private credentials, or unredacted sensitive content
in an issue. For suspected security vulnerabilities, follow `SECURITY.md`
instead of posting exploit details publicly.
