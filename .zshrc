# zsh settings for macOS. ~/.config/shell/common.sh holds the settings that
# bash on Linux shares.

[[ -r "${HOME}/.config/shell/common.sh" ]] && source "${HOME}/.config/shell/common.sh"

# Search the history with Ctrl-R and Ctrl-S. Bind the keys after `set -o vi`.
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

### `.zsh_history`
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY     # append, do not overwrite
setopt INC_APPEND_HISTORY # write each command right away
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE  # skip commands that start with a space
# setopt SHARE_HISTORY

### completions
autoload -Uz compinit && compinit

### aliases
# Delete the .DS_Store files in the home folder. Skips ~/Library and the Trash.
alias cleanup='find "$HOME" \( -path "$HOME/Library" -o -path "$HOME/.Trash" \) -prune -o -type f -name "*.DS_Store" -print -delete 2>/dev/null'

### uv
[[ -r "${HOME}/.local/bin/env" ]] && . "${HOME}/.local/bin/env"
if (( $+commands[uv] )); then
  eval "$(uv generate-shell-completion zsh)"
  eval "$(uvx --generate-shell-completion zsh)"
fi
(( $+commands[pixi] )) && eval "$(pixi completion --shell zsh)"

### private settings for this machine, kept outside this repo
[[ -r "${HOME}/.config/shell/private.sh" ]] && source "${HOME}/.config/shell/private.sh"

### prompt
eval "$(starship init zsh)"

# very important sysinfo
if [[ -o interactive ]]; then
    fastfetch
fi
