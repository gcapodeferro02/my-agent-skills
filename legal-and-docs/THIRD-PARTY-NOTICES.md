# Third-party notices

This repository may reference or redistribute skill snapshots, plugin content, and documentation originating outside this project.

Important: third-party content is not automatically covered by this repository's license or by any implied authorization to redistribute. The repository treats bundled skill content as requiring provenance verification before public redistribution.

## Current default policy

The bundled content under `skills/` is treated conservatively as `REVIEW_REQUIRED` unless the source, license, and redistribution rights have been explicitly confirmed.

This means:

- no copy is assumed to be public-domain or free to redistribute;
- no third-party license is assumed to be satisfied by the mere fact that the content is present in a local snapshot;
- any copy kept in the repository remains subject to the original source license and notice requirements;
- public redistribution requires explicit verification and documentation before release.

## Source inventory

For each bundled skill, check the corresponding record in `skills-manifest.json` and the catalog at `catalog/SKILLS.md`.

Each record should document:

- name;
- source;
- original path;
- bundled path;
- SHA-256 snapshot hash;
- upstream repository;
- upstream ref (commit or tag);
- upstream source path;
- evidence URL used for review;
- review date;
- factual review notes;
- license name;
- license URL;
- copyright/attribution statement;
- redistribution status;
- provenance status.

The evidence fields are intentionally separate from `source_url`: the source
URL identifies where the content came from, while `evidence_url` identifies
the license, notice, or repository policy used to evaluate redistribution.
Blank evidence fields mean that the item remains blocked.

## Default notice for bundled skills

The repository currently treats all bundled skill snapshots as third-party content with provenance under review. Until a human review confirms a given skill's license and redistribution rights, the safe position is:

- do not redistribute the copied payload as if it were project-owned content;
- keep its origin metadata and path in the manifest;
- prefer local installation or direct source installation where licensing permits;
- require explicit permission for public redistribution.

## Required fields for every third-party item

For any skill later confirmed as redistributable, record:

- Origin URL
- Upstream repository and immutable ref
- Upstream source path
- Author/organization
- License
- License text URL
- Evidence URL
- Review date and factual review notes
- Local path in this repo
- Modifications
- Redistribution status
- Attribution requirements
- Mandatory notices

If a license requires preserving notices or including the full license text, keep those notices in the repository alongside the copied material.
