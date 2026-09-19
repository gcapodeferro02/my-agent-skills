# Licensing Provenance Audit Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace placeholder provenance metadata with evidence-backed records where possible, preserve conservative blocking everywhere else, and publish the validated repository state.

**Architecture:** Treat `skills-manifest.json` as the provenance ledger and add explicit evidence fields that connect every approved entry to an upstream repository, source path, license, and review date. Keep restore behavior deny-by-default, and make verification reject unsupported approval claims while allowing intentionally blocked entries to pass with warnings.

**Tech Stack:** PowerShell 5-compatible scripts, JSON, Markdown, Git, GitHub repository metadata/API lookups.

**Spec:** `docs/superpowers/specs/2026-09-18-licensing-provenance-audit-design.md`

## Global Constraints

- Do not infer redistribution rights from GitHub visibility, repository ownership, or the presence of a file.
- Ambiguous or incomplete evidence remains `review_required` and is not treated as redistributable.
- `-AllowLocalReference` is local-use only and never grants publication rights.
- Do not delete bundled snapshots automatically.
- Run `scripts\verify.ps1` and `git diff --check` before committing the implementation.
- Include `Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>` in implementation commits.

---

### Task 1: Add a machine-readable provenance evidence schema

**Files:**
- Modify: `skills-manifest.json`
- Modify: `THIRD-PARTY-NOTICES.md`
- Modify: `catalog/SKILLS.md`

**Interfaces:**
- Consumes: Existing manifest fields `name`, `source`, `original_path`, `bundled_path`, `sha256`, `license`, `license_url`, `source_url`, `redistribution`, and `provenance_status`.
- Produces: Each manifest entry also has `upstream_repository`, `upstream_ref`, `upstream_path`, `evidence_url`, `reviewed_at`, and `review_notes`.

- [ ] **Step 1: Write the failing metadata check**

Add a temporary PowerShell assertion block to the verification script that
expects every entry to contain the new evidence properties and run:

```powershell
Set-Location 'C:\Users\guilherme.henrique\my-agent-skills'
.\scripts\verify.ps1
```

Expected: the command reports missing evidence fields for the current entries.

- [ ] **Step 2: Populate the schema without changing approval status**

Add the new properties to every entry. For entries not yet verified, use:

```json
"upstream_repository": "",
"upstream_ref": "",
"upstream_path": "",
"evidence_url": "",
"reviewed_at": "",
"review_notes": "No reproducible upstream license evidence recorded yet."
```

Do not change `license`, `redistribution`, or `provenance_status` merely to
make the schema complete.

- [ ] **Step 3: Document the required evidence fields**

Update `THIRD-PARTY-NOTICES.md` with the exact field meanings and update
`catalog/SKILLS.md` so a reader can distinguish blocked, conditional, and
approved entries.

- [ ] **Step 4: Run the metadata check**

Run:

```powershell
Set-Location 'C:\Users\guilherme.henrique\my-agent-skills'
.\scripts\verify.ps1
```

Expected: no missing-field failure; all entries remain conservatively blocked
until the source audit supplies evidence.

- [ ] **Step 5: Commit**

```powershell
git add skills-manifest.json THIRD-PARTY-NOTICES.md catalog/SKILLS.md
git commit -m "chore: add provenance evidence fields`n`nCo-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
```

### Task 2: Audit the official Anthropic plugin snapshots

**Files:**
- Modify: `skills-manifest.json`
- Create: `third-party-notices/anthropics-claude-plugins-official.md`

**Interfaces:**
- Consumes: Entries whose `source` is `claude-marketplaces` and whose names
  contain `claude-plugins-official`.
- Produces: Evidence-backed metadata only for source paths and licenses that
  are explicitly documented by `anthropics/claude-plugins-official`.

- [ ] **Step 1: Enumerate exact upstream paths**

For each matching entry, derive the upstream path from the name after
`claude-marketplaces-claude-plugins-official-`, then verify the path against
the upstream repository directory tree and its current default branch.

- [ ] **Step 2: Inspect repository license and notices**

Check the repository root `LICENSE`, `NOTICE`, plugin-specific license files,
and any marketplace metadata. Record the exact URL and commit/ref used for
each conclusion; do not assume one repository-level license covers nested
third-party plugins.

- [ ] **Step 3: Write evidence for only unambiguous entries**

For an entry with explicit source and redistribution permission, set:

```json
"upstream_repository": "https://github.com/anthropics/claude-plugins-official",
"upstream_ref": "<verified commit or tag>",
"upstream_path": "<verified source path>",
"evidence_url": "<stable license or notice URL>",
"reviewed_at": "2026-09-18",
"review_notes": "<short factual basis>"
```

Set `license`, `license_url`, `redistribution`, `attribution_required`, and
`provenance_status` only to values supported by the inspected evidence.
Leave entries blocked if nested ownership or redistribution terms are unclear.

- [ ] **Step 4: Preserve attribution**

Create `third-party-notices/anthropics-claude-plugins-official.md` with the
repository URL, reviewed ref, source paths, license URLs, required notices,
and a statement that the file is an inventory rather than legal advice.

- [ ] **Step 5: Verify this source group**

Run:

```powershell
.\scripts\verify.ps1
```

Expected: approved entries have complete evidence; ambiguous entries produce
warnings and remain blocked; no hash or path failures occur.

- [ ] **Step 6: Commit**

```powershell
git add skills-manifest.json third-party-notices/anthropics-claude-plugins-official.md
git commit -m "docs: record official plugin provenance evidence`n`nCo-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
```

### Task 3: Audit the thedotmack and user-origin snapshots

**Files:**
- Modify: `skills-manifest.json`
- Create: `third-party-notices/thedotmack-claude-mem.md`
- Create: `third-party-notices/local-user-snapshot.md`

**Interfaces:**
- Consumes: Entries whose names contain `claude-marketplaces-thedotmack` and
  the `claude-user-use-findskill` entry.
- Produces: Separate evidence records, with no cross-source license inference.

- [ ] **Step 1: Verify the thedotmack upstream repository**

Locate the exact upstream repository for the `thedotmack` snapshots and inspect
its root license, plugin-specific notices, and source paths. If the upstream
license does not explicitly permit redistribution of the copied files, keep
all matching entries at `unknown` / `review_required`.

- [ ] **Step 2: Record the thedotmack evidence**

Update only fields supported by the upstream files and write
`third-party-notices/thedotmack-claude-mem.md` with source URLs, refs, paths,
license text URLs, and attribution requirements.

- [ ] **Step 3: Classify the user-origin snapshot**

Treat `claude-user-use-findskill` as unverified unless a local author and
explicit license grant are documented in the repository. Do not convert a
personal snapshot into project-owned material by labeling it `MIT`.

- [ ] **Step 4: Verify and commit**

Run:

```powershell
.\scripts\verify.ps1
```

Then commit:

```powershell
git add skills-manifest.json third-party-notices/thedotmack-claude-mem.md third-party-notices/local-user-snapshot.md
git commit -m "docs: separate third-party and local provenance records`n`nCo-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
```

### Task 4: Enforce approval invariants in verification

**Files:**
- Modify: `scripts/verify.ps1`
- Modify: `restore.ps1`
- Modify: `setup.ps1`

**Interfaces:**
- Consumes: The evidence fields introduced in Task 1.
- Produces: A verifier that fails unsupported approval claims and restore
  scripts that continue to block unverified entries.

- [ ] **Step 1: Add failing approval-invariant cases**

Add checks for these invalid states:

```powershell
$approved = $entry.redistribution -eq 'allowed' -and $entry.provenance_status -eq 'verified'
if ($approved -and ([string]::IsNullOrWhiteSpace($entry.source_url) -or
    [string]::IsNullOrWhiteSpace($entry.license_url) -or
    [string]::IsNullOrWhiteSpace($entry.evidence_url) -or
    [string]::IsNullOrWhiteSpace($entry.reviewed_at))) {
    # fail the entry
}
```

Expected: a deliberately malformed approved entry causes a non-zero exit.

- [ ] **Step 2: Implement explicit status validation**

Validate allowed values for `redistribution`, `provenance_status`, and
`attribution_required`. Treat `allowed_with_conditions` as blocked unless a
non-empty `review_notes` field states the conditions and the restore path
requires an explicit local-reference or authorization mode.

- [ ] **Step 3: Make restore filtering consistent**

Update `restore.ps1` and `setup.ps1` to use the same approval predicate and
to print the reason fields for blocked entries. Do not silently treat
`review_required` as approved.

- [ ] **Step 4: Run targeted behavior checks**

Run:

```powershell
.\scripts\verify.ps1
.\restore.ps1 -InternalAuthorized -WhatIf
```

Expected: the verifier succeeds for structurally valid conservative metadata,
and WhatIf output shows only explicitly approved entries for public-safe
restore while identifying local-reference-only content separately.

- [ ] **Step 5: Commit**

```powershell
git add scripts/verify.ps1 restore.ps1 setup.ps1
git commit -m "fix: enforce provenance approval invariants`n`nCo-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
```

### Task 5: Final validation and remote update

**Files:**
- Modify: `README.md`
- Modify: `docs/INSTALLATION.md`
- Modify: `catalog/SKILLS.md`

**Interfaces:**
- Consumes: Final manifest statuses and verification behavior from Tasks 1-4.
- Produces: User-facing documentation that accurately describes the
  approved/blocked split and a validated `origin/main`.

- [ ] **Step 1: Update public documentation**

Document the final counts of `verified`, `review_required`, `unknown`, and
`not_allowed` entries only after deriving them from the manifest. Explain that
local-reference mode does not grant redistribution permission.

- [ ] **Step 2: Run repository checks**

Run:

```powershell
.\scripts\verify.ps1
git diff --check
git status --short
```

Expected: verification exits zero, no whitespace errors are reported, and
every modified file is intentional.

- [ ] **Step 3: Review the final diff**

Run:

```powershell
git diff --stat
git diff -- skills-manifest.json scripts/verify.ps1 restore.ps1 setup.ps1 README.md docs/INSTALLATION.md catalog/SKILLS.md THIRD-PARTY-NOTICES.md
```

Confirm that no entry is marked approved without source, license, evidence,
and review metadata.

- [ ] **Step 4: Commit the final documentation**

```powershell
git add README.md docs/INSTALLATION.md catalog/SKILLS.md
git commit -m "docs: publish audited licensing posture`n`nCo-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
```

- [ ] **Step 5: Push and verify the remote**

Run:

```powershell
git push origin main
git status --short --branch
git log -5 --oneline --decorate
```

Expected: push succeeds, the branch reports `ahead 0`, and the working tree
contains only intentionally untracked local files, if any.

