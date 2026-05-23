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

for caveman_skill in \
  "$HOME/.agents/skills/caveman/SKILL.md" \
  "$HOME/.config/devin/skills/caveman/SKILL.md" \
  "$HOME/.claude/skills/caveman/SKILL.md"; do
  if [ -f "$caveman_skill" ]; then
    perl -0pi -e 's/Default:\s*\*\*full\*\*/Default: **ultra**/g' "$caveman_skill"
  fi
done

cursorrules_src="$repo_dir/.cursorrules"
cursorrules_dest="$HOME/.cursorrules"
if [ -f "$cursorrules_src" ]; then
  cp "$cursorrules_src" "$cursorrules_dest"
fi

droid_agents_src="$repo_dir/droid/AGENTS.md"
droid_agents_dest="$HOME/.factory/AGENTS.md"
if [ -f "$droid_agents_src" ]; then
  mkdir -p "$(dirname "$droid_agents_dest")"
  cp "$droid_agents_src" "$droid_agents_dest"
fi

opencode_agents_src="$repo_dir/opencode/AGENTS.md"
opencode_agents_dest="$HOME/.config/opencode/AGENTS.md"
if [ -f "$opencode_agents_src" ]; then
  mkdir -p "$(dirname "$opencode_agents_dest")"
  cp "$opencode_agents_src" "$opencode_agents_dest"
fi
