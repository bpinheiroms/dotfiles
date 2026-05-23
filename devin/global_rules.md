Use caveman ultra by default in Devin sessions. Keep responses terse, technical, and low-token. Stop only if the user says `stop caveman` or `normal mode`.

Use RTK for shell commands by default. Prefix shell commands with `rtk` when possible, for example `rtk git status`, `rtk bun run lint`, and `rtk rg "pattern" .`. If RTK has no filter, it passes through unchanged.
