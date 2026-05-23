#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd -- "$script_dir/.." && pwd)"
devin_dir="$HOME/.config/devin"
shim_dir="$devin_dir/rtk-shims"
local_bin="$HOME/.local/bin"

mkdir -p "$devin_dir/skills" "$devin_dir/hooks" "$shim_dir" "$local_bin"
cp -R "$repo_dir/devin/skills/rtk" "$devin_dir/skills/"
cp -R "$repo_dir/devin/skills/caveman" "$devin_dir/skills/"
cp "$repo_dir/devin/hooks/token-economy-context.py" "$devin_dir/hooks/token-economy-context.py"
cp "$repo_dir/devin/rtk-shims/shim-template" "$shim_dir/shim-template"
cp "$repo_dir/devin/rtk-shims/generate-shims.py" "$shim_dir/generate-shims.py"
rm -f "$devin_dir/hooks/enforce-rtk.py"
chmod +x "$devin_dir/hooks/token-economy-context.py" "$shim_dir/shim-template" "$shim_dir/generate-shims.py"

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

sed "s#__DEVIN_REAL_BIN__#$real_devin#g" "$repo_dir/devin/devin-wrapper" > "$local_bin/devin"
chmod +x "$local_bin/devin"
"$shim_dir/generate-shims.py" >/dev/null 2>&1 || true

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
if not hooks.get("PreToolUse"):
    hooks.pop("PreToolUse", None)
path.write_text(json.dumps(data, indent=2) + "\n")
PY

python3 -m json.tool "$devin_dir/config.json" >/dev/null
printf 'Devin token economy installed. Start a new devin session; shell commands will pass through RTK PATH shims.\n'
