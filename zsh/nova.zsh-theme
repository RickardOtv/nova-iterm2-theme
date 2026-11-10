# Nova oh-my-zsh theme.
# Uses ANSI color names, so the exact hex comes from the terminal palette
# (iTerm2 profile here, cyberpunk theme in Herdr): cyan #00f0ff, magenta #ff2a9d,
# yellow #fcee0a, red #ff003c.
#
#   ~/neon/ice-breaker feat/ice-breaker ●
#   $ _

# Git: magenta branch, red dot when dirty.
ZSH_THEME_GIT_PROMPT_PREFIX=" %F{magenta}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{red}●"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Herdr pane id (from the herdr plugin), dim, only inside Herdr.
ZSH_THEME_HERDR_PROMPT_PREFIX="%F{8}["
ZSH_THEME_HERDR_PROMPT_SUFFIX="]%f "

_hc_herdr() { (( $+functions[herdr_prompt_info] )) && herdr_prompt_info }

# Blank line between commands, path line, then yellow $ (red after a failed command).
PROMPT=$'\n''$(_hc_herdr)%F{cyan}%~%f$(git_prompt_info)
%(?.%F{yellow}.%F{red})$%f '
RPROMPT='%(?..%F{red}✗ %?%f)'
