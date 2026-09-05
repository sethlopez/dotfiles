# Accounts

`gh` keeps one active account per host. Git takes its identity from config.
The two drift apart, and then a PR opens from one account while its commits are
authored by another.

**Compare them before the first write in an unfamiliar repository.**

```bash
gh auth status                 # every account per host, active one marked
gh api user --jq .login        # the account gh acts as right now
git config user.name
git config user.email
```

**Switch `gh` to match the identity the repository expects.**

```bash
gh auth switch --user work-login
gh auth switch --hostname github.example.com --user work-login
```

With two accounts on one host and no flags, `gh auth switch` toggles between
them. Adding an account needs `gh auth login`, which prompts, so the user runs
it.

**`GH_TOKEN` in the environment overrides every stored account**, and
`gh auth switch` cannot move off it. Unset it before switching, or set it to the
right token.

**Set the git identity per repository when it differs from the global one.**

```bash
git config user.email me@work.example
git config user.name 'Work Name'
```

A `[includeIf "gitdir:~/work/"]` block in the global config does this by
directory, once, for every repository underneath.

**Check the author of commits that have not been pushed.**

```bash
git log origin/main..HEAD --format='%an <%ae>' | sort -u
```

Wrong author on the last commit: `git commit --amend --reset-author`. Wrong on
several, before they are pushed:

```bash
git rebase origin/main --exec 'git commit --amend --no-edit --reset-author'
```

GitHub attributes a commit to whichever account owns its author email. An
address the account does not carry shows as an unlinked name, and a push can be
rejected outright when the account enables email privacy. Use the account's
`ID+login@users.noreply.github.com` address in that case.
