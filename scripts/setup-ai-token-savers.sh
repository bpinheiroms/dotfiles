#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd -- "$script_dir/.." && pwd)"

if ! command -v rtk >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    brew install rtk
  else
    curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
    profile="$HOME/.profile"
    path_line='export PATH="$HOME/.local/bin:$PATH"'
    grep -Fqx "$path_line" "$profile" 2>/dev/null || printf '\n%s\n' "$path_line" >> "$profile"
    # shellcheck source=/dev/null
    . "$profile"
  fi
fi

if ! command -v rtk >/dev/null 2>&1 || ! rtk --version >/dev/null 2>&1; then
  echo "rtk install failed or rtk is not on PATH" >&2
  exit 1
fi

rtk init -g --auto-patch --ultra-compact
rtk init -g --codex --ultra-compact
rtk init -g --opencode --ultra-compact

npx -y skills add JuliusBrussee/caveman -g --all --copy

devin_rule_src="$repo_dir/devin/global_rules.md"
devin_rule_dest="$HOME/.codeium/windsurf/memories/global_rules.md"
if [ -f "$devin_rule_src" ]; then
  mkdir -p "$(dirname "$devin_rule_dest")"
  cp "$devin_rule_src" "$devin_rule_dest"
fi
