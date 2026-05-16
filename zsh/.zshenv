
# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"

# Terminal color defaults for every zsh process, including cmux/Ghostty panes
# that do not start as an interactive login shell.
if [ -z "$TERM" ] || [ "$TERM" = "dumb" ]; then
  export TERM=xterm-256color
fi
export COLORTERM=truecolor
export FORCE_COLOR=3
export CLICOLOR=1
