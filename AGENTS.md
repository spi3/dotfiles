# Repository Guidelines

## Project Structure & Module Organization

This repository stores personal development dotfiles for macOS and Linux. Root setup scripts live at `bootstrap.sh`, `macos_setup.sh`, and `linux_setup.sh`. Shell, Git, Vim, and Zsh configuration files are kept in `dotfiles/` and are symlinked into `$HOME` with a leading dot. App config directories, including Neovim, live in `config/` and are linked into `~/.config/`. macOS profile snippets live in `macos/profile/`. Homebrew package state is managed through the root `Brewfile`.

## Build, Test, and Development Commands

- `sh bootstrap.sh`: run the platform setup, install Oh My Zsh, set Zsh as the default shell, and link files from `dotfiles/` into `$HOME`.
- `sh macos_setup.sh`: install Homebrew, run `brew bundle`, and link macOS profile snippets.
- `sh linux_setup.sh`: install Linux dependencies through `apt`.
- `brew bundle check`: verify that Homebrew dependencies from `Brewfile` are installed.
- `sh -n bootstrap.sh macos_setup.sh linux_setup.sh`: check shell syntax without executing setup actions.

Run setup scripts only after reviewing them, because they replace matching files in `$HOME` with symlinks.

## Coding Style & Naming Conventions

Use POSIX-compatible shell syntax unless a script explicitly requires Bash or Zsh. Keep scripts small, readable, and idempotent where practical. Quote variable expansions that may contain paths, use uppercase names for environment-style variables, and prefer descriptive file names such as `brew_completion.sh`. Dotfiles in `dotfiles/` should be stored without the leading dot, for example `dotfiles/zshrc` becomes `~/.zshrc`.

## Testing Guidelines

There is no automated test suite. Validate changes with `sh -n` for shell syntax and, when available, `shellcheck bootstrap.sh macos_setup.sh linux_setup.sh macos/profile/*.sh`. For install changes, prefer targeted checks such as `brew bundle check` before running full bootstrap. Manually inspect any symlink logic that touches `$HOME`.

## Commit & Pull Request Guidelines

Recent commits use short, imperative or past-tense summaries such as `Set zsh as default` and `Fixed bootstrap`. Keep commit subjects concise and focused on one change. Pull requests should explain the affected platform, list commands tested, and call out any changes that install packages, alter the login shell, or replace files in `$HOME`.

## Security & Configuration Tips

Review any command that downloads and executes remote scripts, especially `curl | sh` patterns. Do not commit machine-specific secrets, tokens, or private host configuration.
