#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd -- "$script_dir/.." && pwd)"
devin_dir="$HOME/.config/devin"

mkdir -p "$devin_dir/skills" "$devin_dir/hooks"
cp -R "$repo_dir/devin/skills/rtk" "$devin_dir/skills/"
cp -R "$repo_dir/devin/skills/caveman" "$devin_dir/skills/"
cp "$repo_dir/devin/hooks/token-economy-context.py" "$devin_dir/hooks/token-economy-context.py"
rm -f "$devin_dir/hooks/enforce-rtk.py"
chmod +x "$devin_dir/hooks/token-economy-context.py"

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
managed_commands = {
    "python3 ~/.config/devin/hooks/token-economy-context.py",
    "rtk hook claude --ultra-compact",
}
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
                "command": "python3 ~/.config/devin/hooks/token-economy-context.py",
                "timeout": 2,
            }
        ],
    }
)
hooks.setdefault("PreToolUse", []).append(
    {
        "matcher": "exec",
        "hooks": [
            {
                "type": "command",
                "command": "rtk hook claude --ultra-compact",
                "timeout": 2,
            }
        ],
    }
)
path.write_text(json.dumps(data, indent=2) + "\n")
PY

python3 -m json.tool "$devin_dir/config.json" >/dev/null
printf 'Devin token economy installed. Restart Devin and run /hooks to verify.\n'
