#!/usr/bin/env bash
set -euo pipefail

if ! command -v rtk >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    brew install rtk
  else
    curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi

rtk init -g --auto-patch --ultra-compact
rtk init -g --codex --ultra-compact
rtk init -g --opencode --ultra-compact

npx -y skills add JuliusBrussee/caveman -g --all --copy
