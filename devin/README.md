# Devin Token Economy

Global Devin for Terminal setup for RTK shell command usage and Caveman-style terse responses.

## Files

- `skills/rtk/SKILL.md`: RTK usage skill for Devin.
- `skills/caveman/SKILL.md`: Caveman response mode skill for Devin.
- `hooks/token-economy-context.py`: injects token-economy context on each user prompt.
- `devin-wrapper`: transparent Devin launcher that prepends RTK command shims to `PATH`.
- `rtk-shims/`: generated executable shims that rewrite supported commands through `rtk rewrite --ultra-compact`.

## Install

```bash
scripts/setup-devin-token-economy.sh
```

The installer:

- copies skills into `~/.config/devin/skills/`
- copies hooks into `~/.config/devin/hooks/`
- copies RTK shims into `~/.config/devin/rtk-shims/`
- installs a transparent `~/.local/bin/devin` wrapper around the real Devin binary
- merges hook config into `~/.config/devin/config.json`
- preserves existing Devin settings and MCP servers

## Validate

Start a new Devin session normally:

```bash
devin -p "Run git status. Then answer exactly: done"
```

Then inspect:

```bash
cat ~/.config/devin/rtk-shims.log
```

Expected behavior:

- external shell commands like `git status` are rewritten to `rtk git status`
- no hook mutation or block/retry loop is used
- prompt context still asks Devin to use Caveman ultra-style concise responses
