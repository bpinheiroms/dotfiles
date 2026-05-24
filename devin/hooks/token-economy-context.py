#!/usr/bin/env python3
import json

print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "UserPromptSubmit",
        "additionalContext": (
            "Token Economy active globally for Devin. "
            "Respond in caveman ultra: terse, technical, no filler, but keep clarity for destructive/security/ambiguous steps. "
            "For shell commands, prefix with `rtk` whenever possible. "
            "Examples: `rtk git status`, `rtk gh pr view 2226 --json files`, `rtk pnpm test`. "
            "Do not use `rtk` for built-in agent tools, only shell commands."
        ),
    }
}))
