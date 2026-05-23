---
name: rtk
description: >
  Token-optimized shell command usage for Devin. Use on every coding task, before shell/tool commands,
  when reading files/searching/running tests/git/builds, or whenever token efficiency matters.
---

Use RTK for shell commands by default.

Rules:
- Prefix shell commands with `rtk` when possible: `rtk git status`, `rtk bun run lint`, `rtk rg "pattern" .`.
- If RTK has no filter, it passes through unchanged.
- For chains, prefix each command: `rtk git status && rtk bun run type-check`.
- Check savings with `rtk gain`.
- Do not use `rtk` for non-shell built-in agent tools.
