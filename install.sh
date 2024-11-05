#!/usr/bin/env bash
set -euo pipefail

###
## INSTALL
## ---
## Symlink dotfiles in their respective locations.
###

echo "Installing dotfiles..."
stow --dotfiles --no-folding git ideavim nvim shell vim zed zsh
echo "Done."
