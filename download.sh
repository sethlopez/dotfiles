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
TARBALL="$REPOSITORY/tarball/main"

if [ -d "$TARGET" ]; then
    echo -e -n "$TARGET already exists. Overwrite? (y/N) "
    read -re -t 15 OVERWRITE_REPLY
    if [[ -z $OVERWRITE_REPLY ]] || [[ $OVERWRITE_REPLY == [nN]* ]]; then
        echo "Exiting."
        exit 1
    fi
fi

if ! command -v "curl" > /dev/null 2>&1; then
    echo "Error: Unable to download dotfiles. Missing 'curl' command." >&2
    exit 1
fi

echo "Downloading dotfiles..."
mkdir -p "$TMP_TARGET"
curl -fsSL "$TARBALL" | tar -xz -C "$TMP_TARGET" --strip-components=1
test -d "$TARGET" && rm -rf "$TARGET"
mv -f "$TMP_TARGET" "$TARGET"
echo "Done. Dotfiles located at $TARGET."
