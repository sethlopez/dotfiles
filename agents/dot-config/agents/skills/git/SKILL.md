---
name: git
description: Local git practice. Covers atomic commits, Conventional Commits, worktrees including bare-repo layouts, trunk-based branching, bisect and blame for debugging, version tags, gitignore for generated files, and keeping secrets out of history. Use when committing, branching, adding a worktree, tagging a version, or coordinating agents working in parallel. Does not cover remotes, pushing, or pull requests.
---

# Git

Rules for local git work, written for one agent or several running at once.

## Isolation

Git isolates by working tree. Each worktree owns its index, its `HEAD`, and its
files. Agents in separate worktrees cannot corrupt each other. Agents sharing
one worktree share all three.

**An agent that writes gets its own worktree and branch.** No exceptions.

**Agents that share a worktree are read-only.** They may run `git log`,
`git show`, `git diff`, `git blame`, and `git grep`. They must not run
`git add`, `git commit`, `git checkout`, `git switch`, `git restore`,
`git stash`, `git reset`, `git rebase`, `git merge`, or `git bisect`. Every one
of those moves the index, `HEAD`, or the files under a peer that is mid-edit.

This holds for everything below. Ignored artifacts, staged changes, and a bisect
in progress are all per worktree.

### Worktrees

Give each writing agent a directory and a branch:

```bash
git worktree add ../proj-feat-auth   -b feat/auth
git worktree add ../proj-feat-import -b feat/import
```

The agent commits inside its own worktree. The orchestrator merges each branch
into trunk, then cleans up:

```bash
git worktree remove ../proj-feat-auth
git branch -d feat/auth
git worktree prune
```

Keep that order. A branch checked out in a worktree cannot be deleted.

- A new worktree has no ignored files. `node_modules/`, `.venv/`, `.env`, and
  build caches do not carry over. Install dependencies and copy local config
  before the agent starts.
- Two worktrees cannot check out one branch. Git refuses with `fatal: '<branch>'
  is already used by worktree at ...`.
- `git worktree list` shows what exists. `git worktree prune` clears records of
  directories deleted by hand.

### Bare repositories

A bare repo holds no working tree of its own, so every worktree is a sibling
under it:

```
proj.git/          bare repo
├── main/          worktree on main
├── feat-auth/     worktree on feat/auth
└── feat-import/   worktree on feat/import
```

`git clone --bare` sets no fetch refspec, so remote-tracking branches never
appear and `origin/main` does not resolve. Set the refspec at clone time:

```bash
git clone --bare git@github.com:user/proj.git proj.git
cd proj.git
git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
git fetch origin
git worktree add main main
```

Run git from inside a worktree, or point at one with `git -C`. Inside a
worktree, `.git` is a file holding a `gitdir:` path into
`proj.git/worktrees/<name>`, not a directory.

---

## Branching

Branch from trunk, and merge back within a few days. Trunk stays deployable. A
branch that lives longer diverges, collects conflicts, and hides integration
risk until the end.

Name branches with the same types used in commit messages:

```
feat/task-creation
fix/duplicate-tasks
refactor/auth-module
chore/update-deps
```

Name a short-lived scratch branch `tmp/`, so an experiment or a spike is
identifiable as disposable later.

For work that is incomplete but safe to integrate, put it behind a flag rather
than holding it on a branch.

### Deleting branches

Delete a branch once its work is on trunk, and delete a `tmp/` branch once the
experiment ends. List the candidates:

```bash
git branch --merged main | rg -v '^\*|^  main$'
```

Delete with `-d`, which refuses a branch holding commits trunk does not have:

```bash
git branch -d feat/auth
# error: the branch 'feat/auth' is not fully merged
```

Do not reach for `-D` to get past that. Either the work has not landed, or trunk
took it as a squash merge, which writes a new commit sharing no history with the
branch. `--merged` misses those, and `git cherry` tells the two apart by patch:

```bash
git cherry main feat/auth    # '-' already upstream, '+' not upstream
```

All `-`, the work is on trunk and `-D` is safe. Any `+`, stop.

A worktree checkout blocks deletion, and `-D` does not override it:

```
error: cannot delete branch 'feat/auth' used by worktree at '...'
```

Remove the worktree first, in the order shown under [Worktrees](#worktrees).

---

## Making a commit

A commit is a recovery point. Commit each slice once its test passes, so there
is always a working state to return to.

### Scope

One commit does one thing. Keep these apart, in separate commits:

- Formatting and behavior
- Refactors and features
- Unrelated fixes found along the way

Renaming a variable inside a feature commit is fine. Reformatting the file it
lives in is not.

Size targets, as guidance rather than limits:

| Lines | Verdict |
|---|---|
| ~100 | Easy to review and revert |
| ~300 | Fine for one logical change |
| 1000+ | Split before committing |

### Stage and inspect

Stage the paths you changed, by name. Never run `git add -A` or `git commit -a`,
which stage files nobody read. That is how `.env` reaches a commit.

Read what you staged, then scan it for credentials:

```bash
git diff --staged

git diff --staged -U0 | rg -i \
  'password|secret|api[_-]?key|token|credential|BEGIN [A-Z ]*PRIVATE KEY|aws_(access|secret)'
```

### What counts as a secret

A string is a secret when possessing it grants access to a system, an account,
or encrypted data, and the fix for a leak is to change it. A value failing that
second test is an identifier.

Treat as a secret:

- **Credentials** — passwords, API keys, bearer, OAuth, and personal access
  tokens, session cookies, signed JWTs, AWS secret keys, GCP service-account
  JSON, Azure client secrets
- **Keys and encryption material** — SSH, TLS, PGP, and signing keys, `.pem`,
  `.key`, `.p12`, and `.jks` files, `BEGIN ... PRIVATE KEY` blocks, seeds and
  recovery phrases
- **Anything embedding one** — `postgres://user:pw@host/db`, a webhook URL
  carrying a token in its path
- **Private URLs** — internal hostnames, unlisted admin routes

Do not stop on these:

- Public keys and certificates, including `.pub` files
- Placeholders such as `your-api-key-here`, `changeme`, `sk-xxxxxxxx`, `<TOKEN>`
- Public identifiers such as client IDs, project IDs, and bucket names
- Localhost connection strings carrying no password

The scan matches names, so a bare high-entropy literal slips past. Judge those
by the test above. An AWS key ID (`AKIA...`) is an identifier, but the secret
key is nearby.

When a value is real and you cannot place it on either list, stop and ask.

### Write the message

Write Conventional Commits:

```
<type>(<scope>): <summary>

<body: why this change is needed>
```

Pick the type from what the commit does:

- `feat` — adds a capability someone can use
- `fix` — corrects behavior that was wrong
- `perf` — same behavior, less time or memory
- `refactor` — restructures code, behavior unchanged
- `style` — formatting only, no change in meaning
- `test` — adds or corrects tests, touching no production code
- `docs` — documentation only
- `build` — build system, packaging, or dependencies
- `ci` — pipeline configuration
- `chore` — maintenance touching none of the above
- `revert` — undoes an earlier commit, naming it in the body

Needing two types is the signal to split the commit. `feat` drives a minor
version bump and `fix` a patch bump, so a commit mixing either with a refactor
misreports what shipped.

The summary is imperative, lowercase, under 72 characters, and carries no
trailing period. Write "add email validation", not "added email validation".

The body explains why the change is needed. The diff already shows what changed,
so do not restate it. Omit the body when the summary covers the change.

Mark a breaking change with `!` after the type, a `BREAKING CHANGE:` footer, or
both:

```
feat(api)!: drop support for v1 task payloads

BREAKING CHANGE: clients sending v1 payloads receive 400. Migrate to the
v2 shape documented in docs/api/tasks.md.
```

---

## What the repository tracks

Commit a generated file when a fresh clone needs it and the build does not
produce it. That covers lockfiles, database migrations, and vendored output from
a generator the build does not run.

Ignore everything the build or the environment produces:

```gitignore
node_modules/
.venv/
dist/
target/
.env
.env.local
*.log
.DS_Store
```

Secrets live in ignored files. Commit a `.env.example` carrying the keys with
empty values, so a fresh clone knows what to fill in.

Adding an already-tracked file to `.gitignore` does nothing. Untrack it first:

```bash
git rm --cached path/to/file
```

`.gitignore` is tracked, so the rules apply in every worktree even though the
ignored files do not.

---

## Investigating history

Find the commit that introduced a behavior:

```bash
git log -S'parseTimestamp' --oneline    # commits changing that string
git log -L :parseDate:src/time.ts       # history of one function
git log --grep='validation' --oneline   # search commit messages
```

Find who last touched a line, ignoring whitespace and following moved code:

```bash
git blame -w -C -L 40,60 src/time.ts
```

Find the commit that broke a test. Give bisect a command and let it run
unattended:

```bash
git bisect start <bad> <good>
git bisect run npm test -- time.test.ts
git bisect reset
```

Bisect moves `HEAD` across dozens of commits, so give it its own worktree.

---

## Versioning with tags

Version anything with consumers as `MAJOR.MINOR.PATCH`. `MAJOR` breaks
consumers, `MINOR` adds behavior, `PATCH` fixes behavior. Treat a change as
breaking whenever you are unsure.

Mark breaking changes in the commit that makes them, so the next bump follows
from history rather than memory.

Tag with an annotated tag, never a lightweight one. Annotated tags carry an
author, a date, and a message, and `git describe` prefers them:

```bash
git tag -a v1.4.0 -m "Release 1.4.0"
```

Derive the shipped version from the tag rather than editing it into several
files, so the tag and the artifact cannot disagree.

---

## Stop conditions

Halt and report rather than working around any of these:

- **A secret appears in a diff or in history.** Tell the user to rotate it. Do
  not quietly rewrite history. Rotation is required whether or not the commit
  ever left the machine.
- **The working tree is dirty when parallel work is about to start.**
- **Two agents hold one worktree and either of them writes.**
- **A merge, rebase, or bisect sits unfinished in a worktree.**
- **A commit is about to land on trunk that no test has run against.**
- **`git branch -D` is about to run on a branch `git cherry` marks `+`.** That
  work exists nowhere else.

## Before every commit

- [ ] `git diff --staged` read in full
- [ ] No secrets in the staged diff
- [ ] Explicit paths staged, no `git add -A`
- [ ] One logical change
- [ ] Tests pass
- [ ] Message is `type(scope): summary`, imperative, under 72 characters
