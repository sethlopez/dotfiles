---
name: github
description: GitHub work through the `gh` CLI. Covers account switching and matching git identity, pull request titles, descriptions, comments, and checks, code review threads, issues, choosing between a local fast-forward and a GitHub merge, forks, and GitHub Actions workflows that run only when needed. Use when opening or updating a pull request, answering review feedback, watching CI, filing or closing an issue, merging, contributing to a repository you do not own, or editing a workflow file.
---

# GitHub

Rules for GitHub work through `gh`. The `git` skill covers local commits,
branches, and worktrees. This one starts where a branch reaches a remote.

This file holds what applies to every GitHub command. Read the reference for
the task at hand before running anything specific to it.

## The `gh` command

**Check for `gh` before planning around it.**

```bash
gh --version
gh auth status
```

When `gh` is missing, tell the user to install it and stop:
`brew install gh` on macOS, or https://cli.github.com elsewhere. Do not install
it yourself.

When `gh` is present but unauthenticated, the user runs `gh auth login`, which
prompts. A non-interactive environment authenticates through `GH_TOKEN` instead.

Without `gh` at all, `git push` still works, and git prints a URL that opens a
pull request in the browser. Report what you could not do from the terminal.

**Confirm which account `gh` acts as before the first write.** It holds one
active account per host, and that account can disagree with the git identity
the repository is configured for. See [ACCOUNTS.md](references/ACCOUNTS.md).

**Ask for fields, not pages.** Every read command takes `--json` and `--jq`, and
the field list is in `gh <command> --help` under `JSON FIELDS`.

```bash
gh pr view 42 --json number,title,state,reviewDecision,mergeStateStatus
gh pr list --json number,title,headRefName --jq '.[] | "\(.number) \(.headRefName)"'
```

**Keep every call non-interactive.** `gh` prompts or opens an editor when a
required value is missing, and an agent shell has nowhere to type. Pass
`--title`, `--body-file`, `--base`, and `--head` explicitly. Set `NO_COLOR=1`
and `GH_PAGER=cat` when output is hard to read.

**Name the repository when the directory is ambiguous.** `-R owner/name` works
from any directory, and is required outside a checkout or when several remotes
point at different repositories.

**Use `gh api` for what the subcommands do not reach.** `{owner}` and `{repo}`
resolve from the current repository.

```bash
gh api repos/{owner}/{repo}/branches/main/protection --jq '.required_status_checks.contexts'
gh api --paginate repos/{owner}/{repo}/issues --jq '.[].number'
```

---

## Where to look

| Task | Reference |
|---|---|
| Opening a PR, writing its title or description, commenting, watching checks, contributing from a fork | [PULL-REQUESTS.md](references/PULL-REQUESTS.md) |
| Writing a description where the repository has no template | [PR-TEMPLATE.md](references/PR-TEMPLATE.md) |
| Requesting review, answering threads, reviewing someone else's PR | [REVIEW.md](references/REVIEW.md) |
| Merging, and choosing between a local fast-forward and GitHub | [MERGING.md](references/MERGING.md) |
| Filing, searching, or closing an issue | [ISSUES.md](references/ISSUES.md) |
| Switching `gh` accounts, or matching one to the git identity | [ACCOUNTS.md](references/ACCOUNTS.md) |
| Writing or editing a GitHub Actions workflow | [WORKFLOWS.md](references/WORKFLOWS.md) |

---

## Stop conditions

Halt and report rather than working around any of these:

- **`gh` is missing or unauthenticated.** The user installs and logs in.
- **No stored `gh` account matches the repository's git identity.** Ask which
  account to use rather than writing from whichever one is active.
- **A required check fails the same way twice.** The change is at fault.
- **A secret appears in a PR body, a comment, or a workflow file.** Tell the
  user to rotate it.
- **A merge would land failing checks or unresolved review threads on trunk.**
- **`--admin`, a force-push to a shared branch, or a branch-protection edit is
  the only way forward.**
- **A workflow change would grant `write` permissions to a job that runs code
  from a fork.** See [WORKFLOWS.md](references/WORKFLOWS.md).
