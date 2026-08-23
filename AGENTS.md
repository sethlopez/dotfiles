# AGENTS.md

This repository contains my macOS user-level configuration files, a.k.a "dotfiles", and scripts to download and manage them.

**Only touch files within this repository.** Installed files in `$HOME` are symlinks into this repository. Editing through a symlink reaches the repository. Creating new files in `$HOME` does not, and will be invisible to git.

**Never commit secrets.** This is a public repository. No tokens, keys, or credentials are allowed. If you find one in this repository, immediately stop and instruct me to rotate the secret.


## Layout

**Packages are top-level directories containing a `dot-*` entry.** Only `dot-` prefixed entries are installed, and each `dot-` becomes a leading period. Everything within an entry is installed regardless of name. Directories are created for real and only files are symlinked, using relative links. A real directory in `$HOME` is expected; a real *file* where a link belongs is drift.

**To add a package:** Create a top-level directory and place a `dot-` prefixed entry inside it. Run `dot install` afterward.

**This repository contains other scripts that are not `dot`.** `download.sh` is used to download these dotfiles from GitHub and bootstrap a new computer. `macos-setup.sh` is invoked by `dot macos-setup` and writes system-level configurations.

## Running commands

**The `dot` script manages the files.** Use `dot --help` to discover its commands. `dot doctor`, `dot install`, and any `dot` command with `--dry-run` may be run freely. Ask before running any other `dot` command.

**Never run `dot macos-setup` or `macos-setup.sh`.** It rewrites system-wide macOS defaults and installs Homebrew packages. You are free to edit it, but only the user is allowed to run it.

**A non-zero exit code from `dot doctor` or `dot-test.sh` is a stop condition.** Diagnose and fix it.

**When `dot doctor` reports a real file where a symlink was expected,** that file holds edits that never reached this repository. Copy its contents into the matching repository file, delete the original, then run `dot install`. Never delete the original before preserving the contents.

## Editing the scripts

**This repository targets bash 3.2 and BSD tools.** `/bin/bash` on macOS is 3.2. Do not use any other version of bash to test. No associative arrays (`declare -A`), no `mapfile`/`readarray`, no case conversion (`${var^^}`, `${var,,}`), no negative array indices, no `&>>`. Prefer BSD-compatible flags for `sed`, `find`, and `stat`.

**Test all changes to `dot` before committing.** Run `bash dot-test.sh ./dot` from the repository root. New functionality requires new test cases in `dot-test.sh`.

**Package contents have no automated tests.** For config files under a package, `dot doctor` confirming the link is the only verification available.

## Committing

**Verify before committing.** Run the test suite for `dot` changes, then `dot install` and `dot doctor`, then commit.

**Commit changes, but never push or rewrite history.** Only the user will do that.

**Write short, capitalized, imperative commit subjects with no prefix and no body,** matching the existing log: "Add fd to Brewfile", "Update nvim config".
