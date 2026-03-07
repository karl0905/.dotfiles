# Dotfiles

This repository is organized for GNU Stow.

## Packages

- `common`: shared shell/editor/terminal config
- `linux`: Linux-specific config packages
- `macos`: macOS-specific config and install helpers
- `exports`: reference files that are kept in git but are not stowed

Each stow package mirrors the final path under `$HOME`.

Examples:

- `common/.config/nvim` -> `~/.config/nvim`
- `common/.zshrc` -> `~/.zshrc`
- `linux/.config/hypr` -> `~/.config/hypr`
- `macos/.config/karabiner/karabiner.json` -> `~/.config/karabiner/karabiner.json`

## Usage

From the repo root:

```bash
stow --target="$HOME" common
```

Add the platform-specific package you want on that machine:

```bash
stow --target="$HOME" linux
stow --target="$HOME" macos
```

Or restow a full machine profile:

```bash
stow --target="$HOME" --restow common linux
stow --target="$HOME" --restow common macos
```

## Notes

- `exports/raycast` is not a stow package. It stores exported config snapshots only.
- `macos-install.sh` bootstraps the current macOS dependency set and then stows `common` and `macos`.
- `macos/Brewfile` remains in the `macos` package because its natural target is `$HOME`.
- `linux-install.sh` bootstraps the current Arch-based Linux dependency set and then stows `common` and `linux`.
