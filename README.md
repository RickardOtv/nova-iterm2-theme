# Nova

A neon theme for iTerm2 + oh-my-zsh, matching my Herdr setup
([herdr-cyberpunk](https://github.com/RickardOtv/herdr-cyberpunk-theme)): same palette,
font, skyline background and prompt.

## What's in it

- `iterm2/herdr-theme.json`: the Herdr theme, the single source of colors.
- `iterm2/build.py`: turns it into iTerm2 files:
  - `Nova.itermcolors`: colors only (import via Profiles > Colors > Color Presets).
  - `nova.json`: full dynamic profile (colors, font, cursor, padding,
    transparency, left option = Alt). `install.sh` adds the skyline background.
- `zsh/nova.zsh-theme`: oh-my-zsh prompt. Cyan path, magenta git branch,
  red dot when dirty, yellow `$` (red after a failed command). Shows the Herdr pane id
  inside Herdr when the `herdr` plugin is on. Same theme works in Herdr and iTerm2.
- `fonts/`: Share Tech Mono (SIL OFL).
- `backgrounds/skyline.png`: the Herdr skyline (made by `skyline.py` in herdr-cyberpunk).

Palette: black `#08080c`, yellow `#fcee0a`, red `#ff003c`, cyan `#00f0ff`,
magenta `#ff2a9d`, green `#1aff8c`.

## Install

```sh
./install.sh
```

It installs the font, copies the background, drops the dynamic profile into
`~/Library/Application Support/iTerm2/DynamicProfiles`, copies the zsh theme into
`$ZSH_CUSTOM/themes`, and sets `ZSH_THEME="nova"` in `.zshrc` (respects `ZDOTDIR`).
Each run first backs up `.zshrc` as `.zshrc.pre-nova.<timestamp>`. It never changes
files in this repo.

To undo: restore the backup (`cp ~/.zshrc.pre-nova.<timestamp> ~/.zshrc`) and delete
`~/Library/Application Support/iTerm2/DynamicProfiles/nova.json`.

Then in iTerm2:

1. Settings > Profiles > **Nova** > Other Actions > Set as Default.
2. Settings > Appearance > General > Theme: **Minimal** (dark flat tab bar, like Herdr).

Optional: add `herdr` to `plugins=(...)` in `~/.zshrc` for the pane id in the prompt.

## Change colors

Edit `iterm2/herdr-theme.json` (or copy the latest from
`~/.config/herdr-app/themes/cyberpunk.json`), run `python3 iterm2/build.py` to refresh
the committed files, then rerun `./install.sh`.

Fan-made, not affiliated with CD Projekt or Cyberpunk 2077.
