# Factory Droid Config

Factory Droid configuration without local proxy routing.

## Restore

```bash
mkdir -p ~/.factory
cp droid/settings.json ~/.factory/settings.json
```

Restart Factory Droid after copying the file.

If you want to preserve the previous Droid config first:

```bash
cp ~/.factory/settings.json ~/.factory/settings.json.bak
```

## Notes

- Uses `factory-dark` because Factory Droid's light theme renders low-contrast text in dark terminal sessions.
- This config does not define custom OpenAI-compatible proxy models.
- This config intentionally omits Droid notification hooks.

## Token Economy Validation

`~/.factory/AGENTS.md` is a global Droid instruction file. It is used for Caveman-style terse responses and RTK shell command guidance.

Known behavior:

- Droid reads `~/.factory/AGENTS.md` and can recall the `rtk` shell prefix from persistent instructions.
- RTK usage in Droid is prompt-level guidance, not a transparent command rewrite hook. Droid may still execute raw commands like `git status` unless prompted or a Droid-native tool hook is added later.

Useful check:

```bash
cat ~/.factory/AGENTS.md
droid exec --cwd "$PWD" "According to your persistent instructions, what prefix should you use for shell commands? Answer with only the prefix."
```
