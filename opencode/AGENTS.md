# OpenCode Agents

This setup intentionally uses only Oh My OpenAgent for OpenCode Go.

- Default agent: `sisyphus`
- Provider: `opencode-go/*`
- Routing/fallbacks: `oh-my-openagent.json`

## Token Economy

- Default communication mode: caveman ultra. Stop only if user says `stop caveman` or `normal mode`.
- Use RTK for shell commands by default. Prefix shell commands with `rtk` when possible.

Do not add local provider-specific orchestration here.
Do not recreate custom GO orchestrators/subagents unless Oh My OpenAgent cannot cover a future use case.
