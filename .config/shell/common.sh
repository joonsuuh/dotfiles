# shellcheck shell=bash
# Shell settings for every machine. ~/.bashrc and ~/.zshrc source this file in
# an interactive shell.

# Edit the command line with vi keys, and files with nvim.
set -o vi
export EDITOR="nvim"
export VISUAL="${EDITOR}"

# Free Ctrl-S for the forward history search.
stty -ixon

# pinentry asks in this terminal when it has no window.
# Check which pinentry runs: readlink -f "$(command -v pinentry)"
GPG_TTY="$(tty)"
export GPG_TTY

# k9s keeps its config with the other tools, also on macOS.
export K9S_CONFIG_DIR="${HOME}/.config/k9s"
