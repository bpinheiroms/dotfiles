# Factory Droid Config

Factory Droid configuration for using CLIProxyAPI with OpenAI Codex accounts.

## Requirements

- CLIProxyAPI installed locally.
- Codex accounts authenticated in CLIProxyAPI.
- CLIProxyAPI exposing the OpenAI-compatible endpoint at `http://localhost:8320/v1`.

## Install CLIProxyAPI

Repository:

```bash
git clone https://github.com/router-for-me/CLIProxyAPI.git
```

If you already have Go installed, a typical local install is:

```bash
cd CLIProxyAPI
go build -o cli-proxy-api-plus .
```

If you prefer, you can also use the binary bundled by VibeProxy, but it is not required if you install CLIProxyAPI directly.

## Configure CLIProxyAPI

Copy the provided config and adjust only if needed:

```bash
mkdir -p ~/.cli-proxy-api
cp droid/standalone-config.yaml ~/.cli-proxy-api/standalone-config.yaml
```

Authenticate your Codex accounts into `~/.cli-proxy-api`, then start the proxy:

```bash
cli-proxy-api-plus -config ~/.cli-proxy-api/standalone-config.yaml
```

Validate the proxy:

```bash
curl -sS http://localhost:8320/v1/models | jq -r '.data[].id'
```

Expected models include:

- `gpt-5.5`
- `gpt-5.4`
- `gpt-5.4-mini`
- `gpt-5.3-codex`
- `gpt-5.3-codex-spark`
- `gpt-5.2`

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
- Droid talks to CLIProxyAPI on `8320`. Account rotation is handled inside CLIProxyAPI.
- OpenAI-compatible providers use `baseUrl` ending in `/v1`.
- The `apiKey` value is the local proxy placeholder expected by CLIProxyAPI, not a real OpenAI API key.
- The included `standalone-config.yaml` enables request logging plus explicit `round-robin` routing with `session-affinity: false`.
- The `gpt-5.4(high)`, `gpt-5.4(xhigh)`, `gpt-5.4(medium)`, and `gpt-5.4(low)` aliases are included because they were validated against the local CLIProxyAPI endpoint.
- This config intentionally omits Droid notification hooks.
