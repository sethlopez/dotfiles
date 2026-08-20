#!/usr/bin/env bash
# Regression suite for dot. Usage: suite.sh /path/to/dot
set -u
DOT_SRC="$1"
PASS=0; FAIL=0
ok()  { PASS=$((PASS+1)); printf 'ok   %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf 'FAIL %s\n     %s\n' "$1" "${2:-}"; }
check() { if [ "$2" = "$3" ]; then ok "$1"; else bad "$1" "want [$3] got [$2]"; fi; }

export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
export GIT_CONFIG_GLOBAL=/tmp/gc GIT_CONFIG_SYSTEM=/dev/null; : > /tmp/gc

fresh() {
  rm -rf /tmp/tt; export HOME=/tmp/tt/home; R="$HOME/dotfiles"
  mkdir -p "$R"/zsh "$R"/git/dot-config/git "$R"/agents/dot-agents/skills/bash "$HOME/bin"
  echo "# zshrc" > "$R"/zsh/dot-zshrc
  echo "note"   > "$R"/zsh/README.md
  echo "[user]" > "$R"/git/dot-config/git/config
  echo "old"    > "$R"/git/dot-config/git/ignore
  echo "---"    > "$R"/agents/dot-agents/skills/bash/SKILL.md
  sed 's|REPOSITORY="https://github.com/sethlopez/dotfiles"|REPOSITORY="/tmp/rem.git"|' "$DOT_SRC" > "$R"/dot
  chmod +x "$R"/dot; ln -sf "$R"/dot "$HOME/bin/dot"; DOT="$HOME/bin/dot"
}

fresh; "$DOT" install -q
check "leaf file linked"      "$([ -L "$HOME/.zshrc" ] && echo y)" "y"
check "nested file linked"    "$([ -L "$HOME/.config/git/config" ] && echo y)" "y"
check "dirs are real"         "$([ -d "$HOME/.config/git" ] && [ ! -L "$HOME/.config" ] && echo y)" "y"
check "link is relative"      "$(readlink "$HOME/.zshrc")" "dotfiles/zsh/dot-zshrc"
check "nested link relative"  "$(readlink "$HOME/.config/git/config")" "../../dotfiles/git/dot-config/git/config"
check "non-dot- skipped"      "$([ -e "$HOME/README.md" ] && echo leaked || echo n)" "n"
check "doctor exits 1 (no git)" "$("$DOT" doctor >/dev/null 2>&1; echo $?)" "1"
check "install is idempotent" "$("$DOT" install -q >/dev/null 2>&1; echo $?)" "0"

mv "$R"/git/dot-config/git/ignore "$R"/git/dot-config/git/attributes
"$DOT" install -q
check "renamed file: new link"    "$([ -L "$HOME/.config/git/attributes" ] && echo y)" "y"
check "renamed file: old cleared" "$([ -e "$HOME/.config/git/ignore" ] && echo stale || echo n)" "n"

fresh; "$DOT" install -q
rm "$HOME/.zshrc"; echo "hand edited" > "$HOME/.zshrc"
rm -f "$HOME/.config/git/config"
out="$("$DOT" install 2>&1)"; rc=$?
check "drift aborts"            "$rc" "1"
check "drift: nothing written"  "$([ -e "$HOME/.config/git/config" ] && echo wrote || echo n)" "n"
check "drift message"           "$(echo "$out" | grep -c 'real file where a symlink')" "1"

fresh; "$DOT" install -q
rm "$HOME/.zshrc"; ln -s /etc/hostname "$HOME/.zshrc"
"$DOT" install >/dev/null 2>&1
check "foreign link untouched"  "$(readlink "$HOME/.zshrc")" "/etc/hostname"

fresh; "$DOT" install -q
out="$("$DOT" --dry-run install 2>&1)"
check "dry-run changes nothing" "$(echo "$out" | grep -c 'Would execute')" "0"
fresh
out="$("$DOT" --dry-run install 2>&1)"
check "dry-run on empty home"   "$([ -e "$HOME/.zshrc" ] && echo wrote || echo n)" "n"
check "dry-run reports work"    "$([ "$(echo "$out" | grep -c 'Would execute')" -gt 0 ] && echo y)" "y"

fresh; "$DOT" install -q; echo mine > "$HOME/.config/git/local"
"$DOT" uninstall -q
check "uninstall removes links" "$([ -e "$HOME/.zshrc" ] && echo left || echo n)" "n"
check "user file survives"      "$(cat "$HOME/.config/git/local" 2>/dev/null)" "mine"
fresh; "$DOT" install -q; "$DOT" uninstall -q
check "empty dirs pruned"       "$([ -d "$HOME/.config" ] && echo left || echo n)" "n"

fresh; "$DOT" install -q zsh
check "single package: linked"   "$([ -L "$HOME/.zshrc" ] && echo y)" "y"
check "single package: isolated" "$([ -e "$HOME/.config/git/config" ] && echo leaked || echo n)" "n"
"$DOT" install -q
"$DOT" uninstall -q zsh
check "single uninstall isolated" "$([ -L "$HOME/.config/git/config" ] && echo y)" "y"

fresh
check "bad package"   "$("$DOT" install nope 2>&1 | grep -c "Not a package")" "1"
check "bad command"   "$("$DOT" bogus 2>&1 | grep -c "Unknown command")" "1"
check "bad option"    "$("$DOT" --nope install 2>&1 | grep -c "Unknown option")" "1"
check "foreign flag"  "$("$DOT" install --force 2>&1 | grep -c "does not apply")" "1"
check "doctor operand" "$("$DOT" doctor zsh 2>&1 | grep -c "takes no package")" "1"
check "no args usage" "$("$DOT" >/dev/null 2>&1; echo $?)" "2"
check "help exits 0"  "$("$DOT" --help >/dev/null 2>&1; echo $?)" "0"
check "flag after cmd" "$("$DOT" install zsh --dry-run 2>&1 | grep -c 'Would execute')" "$("$DOT" --dry-run install zsh 2>&1 | grep -c 'Would execute')"

rm -rf /tmp/rem.git /tmp/sd
fresh
git init -q /tmp/sd && cp -r "$R"/. /tmp/sd/ && git -C /tmp/sd add -A >/dev/null
git -C /tmp/sd commit -qm init && git -C /tmp/sd branch -M main
git clone -q --bare /tmp/sd /tmp/rem.git && git -C /tmp/sd remote add origin /tmp/rem.git
"$DOT" install -q
"$DOT" upgrade -q 2>/dev/null
check "upgrade converts"  "$(git -C "$R" rev-parse --abbrev-ref HEAD 2>/dev/null)" "main"
check "converted clean"   "$(git -C "$R" status --porcelain | wc -l | tr -d ' ')" "0"
check "doctor clean"      "$("$DOT" doctor >/dev/null 2>&1; echo $?)" "0"
echo "# up" >> /tmp/sd/zsh/dot-zshrc
git -C /tmp/sd commit -qam u >/dev/null && git -C /tmp/sd push -q origin main
"$DOT" upgrade -q
check "fast-forward"      "$(grep -c '# up' "$HOME/.zshrc")" "1"
echo x >> "$R"/zsh/dot-zshrc
check "dirty refused"     "$("$DOT" upgrade 2>&1 | grep -c 'Uncommitted changes')" "1"
"$DOT" upgrade --force -q 2>/dev/null
check "force discards"    "$(git -C "$R" status --porcelain | wc -l | tr -d ' ')" "0"

printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
