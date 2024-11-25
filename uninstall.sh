#!/usr/bin/env bash
set -euo pipefail

###
## UNINSTALL
## ---
## Remove symlinked dotfiles.
###

echo "Uninstalling dotfiles..."
stow --delete --dotfiles --no-folding alacritty git ideavim nvim shell vim zed zsh
echo "Done."
