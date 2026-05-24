#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd -- "$script_dir/.." && pwd)"
devin_dir="$HOME/.config/devin"
shim_dir="$devin_dir/rtk-shims"
local_bin="$HOME/.local/bin"
zshenv="$HOME/.zshenv"

if ! command -v rtk >/dev/null 2>&1; then
  printf 'Could not find rtk in PATH.\n' >&2
  exit 1
fi

rtk mkdir -p "$devin_dir/skills" "$devin_dir/hooks" "$shim_dir" "$local_bin"
rtk cp -R "$repo_dir/devin/skills/rtk" "$devin_dir/skills/"
rtk cp -R "$repo_dir/devin/skills/caveman" "$devin_dir/skills/"
rtk cp "$repo_dir/devin/hooks/token-economy-context.py" "$devin_dir/hooks/token-economy-context.py"
rtk cp "$repo_dir/devin/rtk-shims/shim-template" "$shim_dir/shim-template"
rtk cp "$repo_dir/devin/rtk-shims/generate-shims.py" "$shim_dir/generate-shims.py"
rtk rm -f "$devin_dir/hooks/enforce-rtk.py"
rtk chmod +x "$devin_dir/hooks/token-economy-context.py" "$shim_dir/shim-template" "$shim_dir/generate-shims.py"

devin_cmd="$(command -v devin || true)"
if [ -z "$devin_cmd" ]; then
  printf 'Could not find devin in PATH.\n' >&2
  exit 1
fi

real_devin="$(python3 - "$devin_cmd" <<'PY'
import os
import sys
path = sys.argv[1]
if os.path.isfile(path):
    with open(path, "r", errors="ignore") as handle:
        for line in handle:
            if line.startswith("real_devin="):
                value = line.split("=", 1)[1].strip().strip('"')
                if value != "__DEVIN_REAL_BIN__":
                    print(value)
                    raise SystemExit
print(os.path.realpath(path))
PY
)"

if [ ! -x "$real_devin" ]; then
  printf 'Resolved Devin binary is not executable: %s\n' "$real_devin" >&2
  exit 1
fi

rtk rm -f "$local_bin/devin"
rtk sed "s#__DEVIN_REAL_BIN__#$real_devin#g" "$repo_dir/devin/devin-wrapper" > "$local_bin/devin"
rtk chmod +x "$local_bin/devin"
rtk python3 "$shim_dir/generate-shims.py" >/dev/null 2>&1 || true

path_block='
# dotfiles: user-local wrappers
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac'
if ! rtk grep -Fq '# dotfiles: user-local wrappers' "$zshenv" 2>/dev/null; then
  printf '%s\n' "$path_block" >> "$zshenv"
fi

if [ ! -f "$devin_dir/config.json" ]; then
  printf '{\n  "version": 1\n}\n' > "$devin_dir/config.json"
fi

CONFIG_PATH="$devin_dir/config.json" python3 - <<'PY'
import json
import os
from pathlib import Path

path = Path(os.environ["CONFIG_PATH"])
data = json.loads(path.read_text())
hooks = data.setdefault("hooks", {})
managed_commands = (
    f"python3 {Path.home()}/.config/devin/hooks/token-economy-context.py",
    "python3 ~/.config/devin/hooks/token-economy-context.py",
    "rtk hook claude --ultra-compact",
)
claude_hook_command = "rtk hook claude --ultra-compact"
for event, entries in list(hooks.items()):
    hooks[event] = [
        entry
        for entry in entries
        if all(hook.get("command") not in managed_commands for hook in entry.get("hooks", []))
    ]
hooks.setdefault("UserPromptSubmit", []).append(
    {
        "matcher": "",
        "hooks": [
            {
                "type": "command",
                "command": f"python3 {Path.home()}/.config/devin/hooks/token-economy-context.py",
                "timeout": 2,
            }
        ],
    }
)
pre_tool_use = hooks.setdefault("PreToolUse", [])
existing_pre_tool_commands = {
    hook.get("command")
    for entry in pre_tool_use
    for hook in entry.get("hooks", [])
}
if claude_hook_command not in existing_pre_tool_commands:
    pre_tool_use.append(
        {
            "matcher": "",
            "hooks": [
                {
                    "type": "command",
                    "command": claude_hook_command,
                    "timeout": 2,
                }
            ],
        }
    )
path.write_text(json.dumps(data, indent=2) + "\n")
PY

rtk python3 -m json.tool "$devin_dir/config.json" >/dev/null
printf 'Devin token economy installed. Start a new devin session; shell commands will pass through RTK PATH shims.\n'
