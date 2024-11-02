#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/dotfiles"
TMP_TARGET="/tmp/dotfiles"
REPOSITORY="https://github.com/sethlopez/dotfiles"
TARBALL="$REPOSITORY/tarball/master"
REPLY=""

if [ -d "$TARGET" ]; then
    echo "$TARGET already exists. Overwrite? (y/N)" >&2
    read -re -t 15
    if [[ -z $REPLY ]] || [[ $REPLY == [nN]* ]]; then
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
if [ -d "$TARGET" ]; then
    rm -rf "$TARGET"
fi
mv "$TMP_TARGET" "$TARGET"
rm -rf "$TMP_TARGET"
echo "Download complete!"
echo "Run '$TARGET/dot.sh install' to start installation."
