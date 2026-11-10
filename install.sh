#!/bin/bash
# Installs the Nova look for iTerm2 + oh-my-zsh.
# Backs up .zshrc as .zshrc.pre-nova.<timestamp> before changing ZSH_THEME.
set -e
trap 'echo "Install failed at line $LINENO. Nothing after that step was changed." >&2' ERR
cd "$(dirname "$0")"

ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"
OMZ="${ZSH:-$HOME/.oh-my-zsh}"
ZC="${ZSH_CUSTOM:-$OMZ/custom}"

# Check everything first, so a failure changes nothing.
python3 -c 'pass' 2>/dev/null || { echo "python3 not found (install Xcode Command Line Tools)." >&2; exit 1; }
[ -f "$OMZ/oh-my-zsh.sh" ] || { echo "oh-my-zsh not found at $OMZ (set ZSH to its folder)." >&2; exit 1; }

# 1. Font: Share Tech Mono (same as Herdr cyberpunk).
mkdir -p ~/Library/Fonts
cp fonts/ShareTechMono-Regular.ttf ~/Library/Fonts/

# 2. Background: Herdr skyline.
BG_DIR="$HOME/Library/Application Support/iTerm2/nova"
mkdir -p "$BG_DIR"
cp backgrounds/skyline.png "$BG_DIR/skyline.png"

# 3. iTerm2 dynamic profile (iTerm2 picks it up live, no restart).
# Written straight to DynamicProfiles so repo files are never changed.
DP="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
mkdir -p "$DP"
python3 iterm2/build.py "$BG_DIR/skyline.png" "$DP/nova.json"

# 4. oh-my-zsh theme. Copied, not linked, so the shell never reads from this repo.
mkdir -p "$ZC/themes"
cp zsh/nova.zsh-theme "$ZC/themes/nova.zsh-theme"

# 5. Set ZSH_THEME="nova". Only the value is swapped; comments and the rest stay.
if grep -qE '^ZSH_THEME=' "$ZSHRC" 2>/dev/null; then
  cp "$ZSHRC" "$ZSHRC.pre-nova.$(date +%Y%m%d-%H%M%S)"
  TMP=$(mktemp)
  sed -E 's/^ZSH_THEME=("[^"]*"|'"'"'[^'"'"']*'"'"'|[^[:space:];#]*)/ZSH_THEME="nova"/' "$ZSHRC" > "$TMP"
  # cat into the file (not mv) so a symlinked .zshrc stays a symlink.
  cat "$TMP" > "$ZSHRC"
  rm -f "$TMP"
else
  echo "No ZSH_THEME line in $ZSHRC: add ZSH_THEME=\"nova\" by hand."
fi

echo "Done."
echo "iTerm2: Settings > Profiles > 'Nova' > Other Actions > Set as Default."
echo "Tab bar: Settings > Appearance > Theme > Minimal."
echo "Open a new tab to see it."
