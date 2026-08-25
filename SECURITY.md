# Security Policy

This is a teaching repository. It holds no code that runs anywhere and no data worth stealing. But every well-run repository has one of these files, so here is a real one, and reading it is part of the lesson.

## Reporting a vulnerability

If you find a security problem in this repository, **do not open a public issue**.

Instead, use GitHub's private reporting: go to the **Security** tab → **Report a vulnerability**.

That opens a private security advisory, visible only to you and the maintainers, so a fix can be prepared before anything becomes public.

## Why this file matters

Three things happen when a file named exactly `SECURITY.md` exists:

1. GitHub surfaces a **Security** link on the repository home page.
2. When someone opens a new issue, GitHub points them here first.
3. Anyone assessing whether your project is well maintained sees that you thought about it.

The name matters. `security.md`, `SECURITY.txt` or `docs/security.md` will not be picked up the same way.

## What never belongs in a repository

Even in a class exercise, build the habit now:

- Passwords, API keys, tokens, connection strings
- Private keys or certificates
- Customer data of any kind
- Anything you would not want on a billboard

Use a `.gitignore` to keep them out. If a secret does get committed, **rotate it**. Deleting the file is not enough, because the history still holds it.

## Supported versions

| Version | Supported |
| --- | --- |
| `main` | ✅ |
| Everything else | ❌ |
