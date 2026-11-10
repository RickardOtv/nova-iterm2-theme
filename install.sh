#!/bin/bash
# Installs the Herdr Cyberpunk look for iTerm2 + oh-my-zsh.
# Backs up ~/.zshrc as ~/.zshrc.bak before changing ZSH_THEME.
set -e
cd "$(dirname "$0")"
REPO=$(pwd)

# 1. Font: Share Tech Mono (same as Herdr cyberpunk).
cp fonts/ShareTechMono-Regular.ttf ~/Library/Fonts/

# 2. Background: Herdr skyline.
BG_DIR="$HOME/Library/Application Support/iTerm2/herdr-cyberpunk"
mkdir -p "$BG_DIR"
cp backgrounds/skyline.png "$BG_DIR/skyline.png"

# 3. iTerm2 dynamic profile (iTerm2 picks it up live, no restart).
python3 iterm2/build.py "$BG_DIR/skyline.png"
DP="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
mkdir -p "$DP"
cp iterm2/herdr-cyberpunk.json "$DP/herdr-cyberpunk.json"

# 4. oh-my-zsh theme (symlinked, so repo edits apply on next shell).
ZC="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZC/themes"
ln -sf "$REPO/zsh/herdr-cyberpunk.zsh-theme" "$ZC/themes/herdr-cyberpunk.zsh-theme"
if grep -q '^ZSH_THEME=' ~/.zshrc; then
  cp ~/.zshrc ~/.zshrc.bak
  sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="herdr-cyberpunk"/' ~/.zshrc
else
  echo "No ZSH_THEME line in ~/.zshrc: add ZSH_THEME=\"herdr-cyberpunk\" by hand."
fi

echo "Done."
echo "iTerm2: Settings > Profiles > 'Herdr Cyberpunk' > Other Actions > Set as Default."
echo "Tab bar: Settings > Appearance > Theme > Minimal."
echo "Open a new tab to see it."
