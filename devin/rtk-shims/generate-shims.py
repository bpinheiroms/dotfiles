#!/usr/bin/env python3
import os
from pathlib import Path

shim_dir = Path(os.environ.get("DEVIN_RTK_SHIM_DIR", Path.home() / ".config/devin/rtk-shims"))
template = shim_dir / "shim-template"
exclude_names = {
    "rtk", "devin", "bash", "zsh", "sh", "python", "python3", "env",
    "basename", "dirname", "cat", "printf", "echo", "command", "awk", "sed",
    "grep", "rg", "head", "tail", "cut", "tr", "sort", "uniq", "wc", "xargs",
    "ps", "pkill", "kill", "sleep", "test", "[", "mkdir", "rm", "ln", "chmod",
    "touch", "date", "pwd", "which", "true", "false", "yes", "tee",
}

shim_dir.mkdir(parents=True, exist_ok=True)
seen = set()
for directory in os.environ.get("PATH", "").split(":"):
    if not directory or Path(directory) == shim_dir:
        continue
    path = Path(directory)
    if not path.is_dir():
        continue
    for child in path.iterdir():
        name = child.name
        if name in seen or name in exclude_names:
            continue
        try:
            if child.is_file() and os.access(child, os.X_OK):
                target = shim_dir / name
                if not target.exists():
                    target.symlink_to(template)
                seen.add(name)
        except OSError:
            pass
