# New PC Setup Checklist

Use this as the reminder list when configuring a new machine from scratch.

## Core Apps

- Ghostty
- Cmux
- Zed
- Android Studio / Android SDK
- Xcode and command line tools

## Homebrew Packages

```bash
brew install \
  git \
  zsh \
  oh-my-posh \
  zsh-autosuggestions \
  neovim \
  yazi
```

## Fonts

- Install `JetBrainsMono Nerd Font Mono`.
- Ghostty uses:

```text
font-family = "JetBrainsMono Nerd Font Mono"
font-size = 14
```

## Terminal

### Ghostty

- Copy `ghostty/config` to the Ghostty config path.
- Current theme: `One Dark`.
- Current cursor: bar, no blink.
- Shell command: `/bin/zsh -l`.

### Cmux

- Copy `cmux/cmux.json`.
- Copy `cmux/session-com.cmuxterm.app.json` as the starter session template.
- Default panes per workspace:
  - `git`
  - `cmd-1`
  - `cmd-2`
  - `file manager`
  - `agent-1`
  - `agent-2`
  - `agent-3`

### Neovim / LazyVim

- Copy `nvim/` to `~/.config/nvim`.
- First run: `nvim .` to let LazyVim install plugins.
- This stack is based on `omerxx/dotfiles`: LazyVim, Treesitter, TypeScript extras, and `mini.files`.

## Shell

### Oh My Zsh

Install Oh My Zsh and use the repo zsh config as the base:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp zsh/.zshrc.example ~/.zshrc
cp zsh/.zshenv ~/.zshenv
```

### Oh My Posh

- Install with Homebrew: `brew install oh-my-posh`.
- Current theme: `spaceship`.
- Config used by `.zshrc.example`:

```bash
eval "$(oh-my-posh init zsh --config /opt/homebrew/opt/oh-my-posh/themes/spaceship.omp.json)"
```

### Zsh Autosuggestions

Install with:

```bash
brew install zsh-autosuggestions
```

The repo config sources it from Homebrew when available.

## Dev Toolchains

Install and configure:

- Volta / Node.js
- pnpm
- Bun
- Go
- Java Zulu 17
- Android SDK
- Google Cloud SDK
- Maestro
- Vite+
- OpenCode
- Factory Droid

## File Manager

Install Yazi:

```bash
brew install yazi
```

Open it from a real interactive Ghostty/Cmux pane:

```bash
yazi
```

Copy `yazi/yazi.toml` to `~/.config/yazi/yazi.toml` so opening text/code files from Yazi uses Neovim.

Exit Yazi with `q`.

## Local Secrets

Do not commit secrets. Put tokens and machine-specific overrides in:

```bash
~/.zshrc.local
```
