This repository contains my user-level configuration files, a.k.a "dotfiles", and scripts to download and manage them.

**Only touch files within this repository.** Installed files in `$HOME` are symlinks into this repository. Editing through a symlink reaches the repository. Creating new files in `$HOME` does not, and will be invisible to git.

## How this project works

**This repository targets portable bash 3.2 and BSD tools.**

**The `dot` script manages the files.** Use `dot --help` to discover its commands. `dot doctor`, `dot install`, and any command with `--dry-run` may be run freely. Ask before running any other command.

**Test all changes to the `dot` script before commits.** Any change to `dot` requires `bash dot-test.sh ./dot` from the repository root. New functionality requires new test cases in `dot-test.sh`.

**Commit changes, but never push or rewrite history.**

**Install and verify changes after commits.** Run `dot install` after a commit followed by `dot doctor` to check that the changes worked. When `dot doctor` reports a real file where a symlink was expected, that file holds edits that never reached the repository. Copy its contents into the matching repository file, delete the file in `$HOME`, then run `dot install`. Never delete it before preserving the contents.

**A non-zero exit code from `dot doctor` or `dot-test.sh` is a stop condition.** Diagnose and fix it.

**Packages are top-level directories containing a `dot-*` entry.** Everything beneath an installed entry comes along regardless of name. Each `dot-` becomes a leading period.

**Never commit secrets.** This is a public repository. No tokens, keys, or credentials are allowed.
