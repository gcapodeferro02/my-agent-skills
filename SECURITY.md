# Security policy

## Reporting vulnerabilities

Please report security issues privately before opening a public issue or disclosing details in a public PR.

Use a private channel for the owner or maintainer and include:

- affected files or scripts;
- reproduction steps;
- impact assessment;
- suggested mitigation.

## Safe execution rules

Before running any script, review the exact commands being executed and the files they touch.

Rules:

- never run untrusted PowerShell or shell scripts from the internet without review;
- never paste secrets, tokens, cookies, or session payloads into Git or issue trackers;
- treat any third-party skill, hook, MCP, or plugin as untrusted code until reviewed;
- prefer direct installation from an official source over bundled redistribution when license checks are unclear;
- apply `-WhatIf` and review logs before destructive file copies or updates.

## Secrets and credentials

The repository must never contain:

- `.env` files or environment dumps;
- API keys or tokens;
- AWS/GitHub/Anthropic/OpenAI credentials;
- private keys, certificates, or PKCS files;
- cookies, browser sessions, or local auth state;
- logs, caches, or local databases with sensitive state.

## Secret scan checklist

Before public publication or release, search for common secret patterns, including:

- `API_KEY`, `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `GITHUB_TOKEN`, `GH_TOKEN`, `PASSWORD`, `SECRET`, `TOKEN`, `PRIVATE_KEY`, `CLIENT_SECRET`, `AWS_ACCESS_KEY`, `AWS_SECRET`
- `.env`, `.env.*`, `.pem`, `.key`, `.p12`, `.pfx`
- directories such as `credentials`, `secrets`, `sessions`, `cookies`, `tokens`

Review matches in context and avoid deleting legitimate documentation references that are intentionally public.

## Third-party content

Skills, hooks, and MCP integrations may execute code or read local files. They require the same caution as any external dependency:

- confirm source and provenance;
- verify licensing and redistribution rights;
- minimize scope and privileges;
- keep the installation path and manifest records up to date.

This repository is a catalog and installation helper, not a blanket authorization to run unreviewed external content.
