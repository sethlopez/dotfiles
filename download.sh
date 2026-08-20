#!/usr/bin/env bash
set -euo pipefail

###
## DOWNLOAD
## ---
## Download dotfiles from GitHub.
###

TARGET="$HOME/dotfiles"
TMP_TARGET="/tmp/dotfiles"
REPOSITORY="https://github.com/sethlopez/dotfiles"
BRANCH="main"
TARBALL="$REPOSITORY/tarball/$BRANCH"

if [ -d "$TARGET" ]; then
    echo -e -n "$TARGET already exists. Overwrite? (y/N) "
    read -re -t 15 OVERWRITE_REPLY
    if [[ -z $OVERWRITE_REPLY ]] || [[ $OVERWRITE_REPLY == [nN]* ]]; then
        echo "Exiting."
        exit 1
    fi
fi

# A clone is preferred: 'dot upgrade' pulls, and changes made here can be
# committed. The tarball is the fallback for a machine without git, and
# 'dot upgrade' converts that tree into a checkout later.
if command -v "git" > /dev/null 2>&1; then
    echo "Cloning dotfiles..."
    test -d "$TARGET" && rm -rf "$TARGET"
    git clone --branch "$BRANCH" "$REPOSITORY" "$TARGET"
    echo "Done. Dotfiles located at $TARGET."
    exit 0
fi

if ! command -v "curl" > /dev/null 2>&1; then
    echo "Error: Unable to download dotfiles. Missing 'git' and 'curl' commands." >&2
    exit 1
fi

echo "Downloading dotfiles..."
echo "Warning: 'git' not found, downloading a tarball instead. Run 'dot upgrade' once git is available to convert it into a checkout." >&2
rm -rf "$TMP_TARGET"
mkdir -p "$TMP_TARGET"
curl -fsSL "$TARBALL" | tar -xz -C "$TMP_TARGET" --strip-components=1
test -d "$TARGET" && rm -rf "$TARGET"
mv -f "$TMP_TARGET" "$TARGET"
echo "Done. Dotfiles located at $TARGET."
