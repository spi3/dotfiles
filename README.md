# dotfiles

Dotfiles for Linux/macOS development.

- `dotfiles/`: files linked into `$HOME` with a leading dot, such as `~/.zshrc`.
- `config/nvim/`: Neovim configuration linked into `~/.config/nvim`.
- `config/herdr/`: Herdr configuration files linked individually into `~/.config/herdr` so runtime state remains local.
- `pi/`: pi coding agent config (settings, keybindings, extensions, skills, prompts, themes) linked into `~/.pi/agent/`. Secrets and sessions stay outside the repo.
- `scripts/`: command-line helpers linked into `~/.local/bin/`.
- `bootstrap.sh`: runs platform setup, installs pi and packages declared in `pi/agent/settings.json`, and creates symlinks.

## Pi commit messages

`pi-commit` sends the staged Git diff to a non-interactive, tool-free pi run and prints a Conventional Commits message. Dry-run mode is the default and caches the message under the repository's Git directory:

```sh
pi-commit             # print/cache a message
pi-commit --apply     # commit using that message
```
