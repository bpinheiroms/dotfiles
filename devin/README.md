# Devin Token Economy

Global Devin for Terminal setup for RTK shell command usage and Caveman-style terse responses.

This is automatic after install: open Ghostty or any zsh terminal and run `devin` normally. The installed `~/.local/bin/devin` wrapper starts the real Devin binary with RTK shims at the front of `PATH`, so shell commands launched through Devin's exec tool are intercepted without changing each command manually.

## Files

- `skills/rtk/SKILL.md`: RTK usage skill for Devin.
- `skills/caveman/SKILL.md`: Caveman response mode skill for Devin.
- `hooks/token-economy-context.py`: injects token-economy context on each user prompt.
- `devin-wrapper`: transparent Devin launcher that prepends RTK command shims to `PATH`.
- `rtk-shims/`: generated executable shims that rewrite supported commands through `rtk rewrite --ultra-compact`.

## Install

```bash
bash scripts/setup-devin-token-economy.sh
```

The installer:

- copies skills into `~/.config/devin/skills/`
- copies hooks into `~/.config/devin/hooks/`
- copies RTK shims into `~/.config/devin/rtk-shims/`
- installs a transparent `~/.local/bin/devin` wrapper around the real Devin binary
- ensures `~/.local/bin` is prepended from `~/.zshenv` so zsh/Ghostty resolve `devin` to the wrapper automatically
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

- any external executable available on PATH can be intercepted by the shim layer
- commands supported by `rtk rewrite`, such as `git status`, are rewritten to `rtk git status`
- unsupported commands pass through to the real executable after removing the shim directory from `PATH`
- no hook mutation or block/retry loop is used
- prompt context still asks Devin to use Caveman ultra-style concise responses
