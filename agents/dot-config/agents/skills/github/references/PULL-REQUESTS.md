# Pull Requests

Opening a PR, writing its title and description, commenting on it, watching its
checks, and contributing from a fork.

## Before opening

Push the branch, then look for a template. GitHub reads one from three
locations only: the repository root, `.github/`, and `docs/`.

```bash
git push -u origin feat/auth
fd -iH -d 3 'pull_request_template'
```

The file is `pull_request_template.md` in either case. Any of the three
locations can hold a `PULL_REQUEST_TEMPLATE/` directory instead, which carries
several. Choose one of those by name with `--template`.

## Title

Write the title as a sentence a person reads in a notification list. Plain
words, sentence case, no `type(scope):` prefix, no trailing period.

Put the tracker ID first, followed by a colon, whenever the work has one:

```
XXX-0000: Add device code login to the CLI
PROJ-1482: Fix login timeouts on slow networks
Drop support for v1 task payloads
```

GitHub cannot link an external tracker by itself, so the prefix is what makes
the PR searchable by ticket. A GitHub issue number stays out of the title, and
goes in the description as a closing keyword.

Look for the ID before you decide the work has none:

```bash
git rev-parse --abbrev-ref HEAD                  # feat/XXX-0000-device-code-login
git log origin/main..HEAD --format='%s%n%b'      # subject and trailers
gh pr list --state merged --limit 10 --json title --jq '.[].title'
```

Ask the user when the branch and the commits carry no ID, and merged PRs show
the prefix.

After the prefix, lead with a verb, name the thing that changed, and stay under
about 70 characters including the ID, since GitHub truncates longer titles in
lists and email. Cut words that carry nothing: "Update the code to", "Some
changes for", "Various fixes".

Never put `WIP` in the title. Open a draft.

A squash merge takes the PR title as the commit subject. Where trunk requires
Conventional Commits, set the subject at merge time rather than bending the
title into one. See [MERGING.md](MERGING.md).

## Writing style

Write descriptions and comments in Simplified Technical English:

- One idea per sentence, 20 words or fewer.
- Active voice, simple tenses, imperative for instructions.
- Short, common words, and the same word for the same thing.

Identifiers, log lines, and error text stay as they are.

## Description

With a project template, keep every heading and fill every section. Leave the
HTML comments in place. They do not render on GitHub, and a later edit needs
the instructions they carry.

Without one, use [PR-TEMPLATE.md](PR-TEMPLATE.md).

Either way, the description answers why the change is needed, what a reviewer
should watch for, and how you verified it. The diff already shows what changed.

Link the issue with a closing keyword — `Closes #123`, `Fixes #123`, or
`Resolves #123`, and `owner/repo#123` across repositories. The keyword works in
the description and in commits that land on the default branch. In a comment it
does nothing.

## Create

Write the body to a file. Multi-line `--body` fights shell quoting.

```bash
gh pr create --base main --head feat/auth \
  --title 'XXX-0000: Add device code login to the CLI' \
  --body-file /tmp/pr-body.md
```

- `--fill` takes the title and body from the commits, so the title arrives in
  commit form. Pass `--title` alongside it, which takes precedence over the
  filled value.
- `--draft` opens a PR that cannot be merged and, in most repositories, skips
  CI. `gh pr ready 42` promotes it, `gh pr ready 42 --undo` sends it back.

## Comments

**Comment when there is new information.** A change of approach mid-review, an
answer to a reviewer's question, a measurement, a dependency on another PR, work
deliberately left out.

**Do not comment on progress.** The timeline already shows pushes, rebases, and
check results.

**Edit the description when the change alters what the PR does.** The
description is what a reviewer reads first and what the merge commit inherits.

```bash
gh pr edit 42 --body-file /tmp/pr-body.md
```

**Keep one status comment rather than a chain.** `--edit-last` rewrites your
previous comment, and `--create-if-none` posts the first one.

```bash
gh pr comment 42 --edit-last --create-if-none --body-file /tmp/status.md
```

## Checks

`--watch` blocks until every check finishes, so no polling loop is needed.
`--fail-fast` returns as soon as one fails. The exit code is non-zero on
failure and 8 while checks are still pending.

```bash
gh pr checks 42 --watch --fail-fast
gh pr checks 42 --json name,bucket,link --jq '.[] | select(.bucket=="fail")'
```

Read the failing job, never the whole run:

```bash
gh run list --branch feat/auth --limit 5 --json databaseId,workflowName,conclusion
gh run view <run-id> --log-failed
gh run view <run-id> --job <job-id> --log | tail -100
```

`--log` on a matrix run is tens of thousands of lines.

Re-run failures once: `gh run rerun <run-id> --failed`. A second identical
failure belongs to the change. A run that fails at a different step, or passes
on the re-run, is a flake — report it and stop re-running.

## Forks

```bash
gh repo fork owner/proj --clone --remote
```

That sets `origin` to the fork and `upstream` to the source.

Sync before starting work. `gh repo sync` with no argument fast-forwards the
local repository from its parent; naming a repository updates that fork on
GitHub:

```bash
gh repo sync                        # local, from upstream
gh repo sync myuser/proj --branch main
```

Open the PR against the source repository:

```bash
gh pr create --repo owner/proj --base main --head myuser:fix/typo
```

Read `CONTRIBUTING.md` first. It governs that repository over anything here.
Fork pull requests run with a read-only token and no secrets, and a first-time
contributor's workflow run waits for a maintainer to approve it. See
[WORKFLOWS.md](WORKFLOWS.md).

## Before opening a pull request

- [ ] Active `gh` account matches this repository's git identity
- [ ] Branch pushed, `--base` and `--head` correct
- [ ] Title reads as a plain sentence, under about 70 characters, with the
      tracker ID first when the work has one
- [ ] Project template filled, or [PR-TEMPLATE.md](PR-TEMPLATE.md) used
- [ ] Issue linked with a closing keyword
- [ ] No secrets in the body
- [ ] Tests run, with the result stated in the description
- [ ] Draft when the work is incomplete
