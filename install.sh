#!/bin/bash
# Installs the Nova look for iTerm2 + oh-my-zsh.
# Backs up ~/.zshrc as ~/.zshrc.bak before changing ZSH_THEME.
set -e
cd "$(dirname "$0")"
REPO=$(pwd)

# 1. Font: Share Tech Mono (same as Herdr cyberpunk).
cp fonts/ShareTechMono-Regular.ttf ~/Library/Fonts/

# 2. Background: Herdr skyline.
BG_DIR="$HOME/Library/Application Support/iTerm2/nova"
mkdir -p "$BG_DIR"
cp backgrounds/skyline.png "$BG_DIR/skyline.png"

# 3. iTerm2 dynamic profile (iTerm2 picks it up live, no restart).
python3 iterm2/build.py "$BG_DIR/skyline.png"
DP="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
mkdir -p "$DP"
cp iterm2/nova.json "$DP/nova.json"

# 4. oh-my-zsh theme (symlinked, so repo edits apply on next shell).
ZC="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZC/themes"
ln -sf "$REPO/zsh/nova.zsh-theme" "$ZC/themes/nova.zsh-theme"
if grep -q '^ZSH_THEME=' ~/.zshrc; then
  cp ~/.zshrc ~/.zshrc.bak
  sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="nova"/' ~/.zshrc
else
  echo "No ZSH_THEME line in ~/.zshrc: add ZSH_THEME=\"nova\" by hand."
fi

echo "Done."
echo "iTerm2: Settings > Profiles > 'Nova' > Other Actions > Set as Default."
echo "Tab bar: Settings > Appearance > Theme > Minimal."
echo "Open a new tab to see it."
