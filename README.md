# dotfiles

Dotfiles for Linux/macOS development.

- `dotfiles/`: files linked into `$HOME` with a leading dot, such as `~/.zshrc`.
- `config/nvim/`: Neovim configuration linked into `~/.config/nvim`.
- `config/herdr/`: Herdr configuration files linked individually into `~/.config/herdr` so runtime state remains local.
- `pi/`: pi coding agent config (settings, keybindings, extensions, skills, prompts, themes) linked into `~/.pi/agent/`. Secrets and sessions stay outside the repo.
- `bootstrap.sh`: runs platform setup and creates symlinks.
