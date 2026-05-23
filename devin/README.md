# Devin Token Economy

Global Devin for Terminal setup for RTK shell command usage and Caveman-style terse responses.

## Files

- `skills/rtk/SKILL.md`: RTK usage skill for Devin.
- `skills/caveman/SKILL.md`: Caveman response mode skill for Devin.
- `hooks/token-economy-context.py`: injects token-economy context on each user prompt.
- `rtk hook claude --ultra-compact`: native RTK hook used directly from Devin's Claude-compatible `PreToolUse` hook to rewrite shell commands before execution.

## Install

```bash
scripts/setup-devin-token-economy.sh
```

The installer:

- copies skills into `~/.config/devin/skills/`
- copies hooks into `~/.config/devin/hooks/`
- merges hook config into `~/.config/devin/config.json`
- preserves existing Devin settings and MCP servers

## Validate

Start a new Devin session and run:

```text
/hooks
```

Then ask Devin to run a shell command. Commands like `git status` should execute as `rtk git status`.

Expected behavior:

- raw shell commands like `git status` are rewritten to `rtk git status`
- no block/retry loop is used
- prompt context still asks Devin to use Caveman ultra-style concise responses
