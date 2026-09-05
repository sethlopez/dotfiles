# Merging

Choosing between a local fast-forward and a GitHub merge, and carrying out
either one.

## Where to merge

Fast-forward locally in a repository you own. Merge through GitHub in every
other case, since only that path satisfies branch protection and records the
approval. Two commands settle which one applies:

```bash
gh api user --jq .login
gh repo view --json nameWithOwner,owner,viewerPermission,isFork,squashMergeAllowed
```

| Observation | Merge where |
|---|---|
| `owner.login` equals your login | Locally, fast-forward |
| Organization repository, `viewerPermission` is `ADMIN`, default branch unprotected | Locally, fast-forward |
| `viewerPermission` is `WRITE`, `TRIAGE`, or `READ` | GitHub |
| Default branch protected, or reviews or checks required | GitHub |
| Anyone but you is a reviewer on the PR | GitHub |
| The PR targets a repository you forked from | GitHub |

Check protection when ownership alone does not settle it:

```bash
gh api repos/{owner}/{repo}/branches/main/protection --jq '.required_pull_request_reviews'
```

`404` means the branch is unprotected. `403` means you are not an admin there,
which answers the question by itself.

## Fast-forward locally

The `git` skill covers the mechanics: rebase onto trunk, `git merge --ff-only`,
then delete the branch.

One step belongs to GitHub. Push the rebased branch before you merge, whenever
a PR is open:

```bash
git push --force-with-lease
```

GitHub marks a PR merged once its head commit is reachable from the base
branch. The rebase rewrote those SHAs. Skip that push, and the PR stays open
and points at commits that exist nowhere.

## Merge through GitHub

| Strategy | Trunk receives | Use when |
|---|---|---|
| Squash | One commit, subject from the PR title | The branch commits are steps toward one change |
| Merge commit | Every branch commit plus a merge | Each branch commit stands alone and is worth keeping |
| Rebase | Every branch commit, replayed | Same as above, in a repository that forbids merge commits |

`gh repo view --json squashMergeAllowed,mergeCommitAllowed,rebaseMergeAllowed`
shows which of the three the repository permits.

Check the state before merging:

```bash
gh pr view 42 --json state,isDraft,reviewDecision,mergeStateStatus \
  --jq '{state,isDraft,reviewDecision,mergeStateStatus}'
```

`mergeStateStatus` says what stands in the way:

- `CLEAN` — ready
- `BLOCKED` — a required review or check is missing
- `BEHIND` — the base moved and the repository requires an update
- `DIRTY` — conflicts, which the branch resolves, not the merge
- `UNSTABLE` — a check failed that protection does not require

```bash
gh pr merge 42 --squash --delete-branch
gh pr merge 42 --squash --auto            # merges itself once checks pass
```

A squash merge takes the PR title as the subject and the accumulated commit
messages as the body. Set `--subject` when trunk expects a different form than
the title, such as Conventional Commits, and `--body-file` when the collected
commit messages read as noise.

```bash
gh pr merge 42 --squash --subject 'feat(auth): add device code login'
```

`--admin` bypasses branch protection. Use it only when the user asks for it by
name, and never on a repository you do not own.
