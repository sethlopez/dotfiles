# Issues

Search before filing, since duplicates cost more to close than to avoid:

```bash
gh issue list --search 'login timeout in:title,body' --state all --limit 20
gh search issues 'login timeout' --repo owner/name --state open
```

Create with a body file, and use a template when the repository has one:

```bash
gh issue create --title 'Login times out after 30s on slow networks' \
  --body-file /tmp/issue.md --label bug --assignee @me
```

A good issue carries what happened, what was expected, how to reproduce it, and
the version or commit. Guesses about the cause go in a comment, not the body.

Start work from the issue so the branch links back to it:

```bash
gh issue develop 123 --name fix/login-timeout --base main --checkout
```

A pull request closes the issue on merge through a closing keyword in its
description. See [PULL-REQUESTS.md](PULL-REQUESTS.md).

Close with a reason when no PR closes it:

```bash
gh issue close 123 --reason 'not planned' --comment 'Fixed upstream in curl 8.5.'
gh issue close 123 --duplicate-of 98
```
