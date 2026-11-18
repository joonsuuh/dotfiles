# dotfiles

Configuration for Neovim, kitty, tmux, starship, git, and the shell on macOS and Linux.

## Contents

| Path                                         | Link target in `~`         | Description                                           |
| -------------------------------------------- | -------------------------- | ----------------------------------------------------- |
| `.config/nvim/`                              | `.config/nvim`             | Neovim 0.12. `vim.pack` manages the plugins.          |
| `.config/kitty/`                             | `.config/kitty`            | The kitty terminal.                                   |
| `.config/tmux/`                              | `.config/tmux`             | tmux with the TPM plugin manager.                     |
| `.config/starship.toml`                      | `.config/starship.toml`    | The starship prompt.                                  |
| `.config/git/config`, `.config/git/personal` | `.config/git/`             | Git settings, and the identity for this repo.         |
| `.config/shell/common.sh`                    | `.config/shell/common.sh`  | Settings that bash and zsh share.                     |
| `.config/uv/uv.toml`                         | `.config/uv/uv.toml`       | uv uses only the Python builds that it installs.      |
| `.config/k9s/skins/`, `.config/k9s/aliases.yaml` | `.config/k9s/`           | k9s skins (Catppuccin) and resource aliases.          |
| `.ipython/profile_default/ipython_config.py` | `.ipython/profile_default/` | IPython with vi keys.                               |
| `.jupyter/lab/user-settings/`                | `.jupyter/lab/user-settings` | JupyterLab theme and notebook settings.             |
| `.zshrc`, `.zprofile`                        | `.zshrc`, `.zprofile`      | zsh on macOS.                                         |
| `.bashrc`                                    | `.bashrc`                  | bash on Linux (Ubuntu).                               |
| `darwin/`                                    | None                       | macOS setup. Run `darwin/.macos` once on a new Mac.   |
| `keyboard.vil`                               | None                       | Keyboard layout. Load it in the Vial app.             |

## Requirements

- Neovim 0.12 or later.
- Git, make, a C compiler, and the [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) 0.26.1 or later.
  nvim-treesitter needs them to build the parsers.
- A [Nerd Font](https://www.nerdfonts.com/). kitty uses ComicShannsMono Nerd Font.
- [starship](https://starship.rs/), [fastfetch](https://github.com/fastfetch-cli/fastfetch), kitty, and tmux.
- [uv](https://docs.astral.sh/uv/), to install `jupytext` for jupytext.nvim.
- Optional: [pixi](https://pixi.sh/) for projects that need conda-forge packages.

## Install

1. Clone the repository to `~/dotfiles`:

   ```bash
   git clone https://github.com/joonsuuh/dotfiles.git ~/dotfiles
   ```

1. Move any existing file or folder at a link target out of the way, and then create the links:

   ```bash
   cd ~
   mkdir -p .config/git .config/shell
   ln -s ../dotfiles/.config/nvim .config/nvim
   ln -s ../dotfiles/.config/kitty .config/kitty
   ln -s ../dotfiles/.config/tmux .config/tmux
   ln -s ../dotfiles/.config/starship.toml .config/starship.toml
   ln -s ../../dotfiles/.config/git/config .config/git/config
   ln -s ../../dotfiles/.config/git/personal .config/git/personal
   ln -s ../../dotfiles/.config/shell/common.sh .config/shell/common.sh
   mkdir -p .config/k9s .ipython/profile_default .jupyter/lab
   ln -s ../../dotfiles/.config/k9s/skins .config/k9s/skins
   ln -s ../../dotfiles/.config/k9s/aliases.yaml .config/k9s/aliases.yaml
   ln -s ../../dotfiles/.ipython/profile_default/ipython_config.py .ipython/profile_default/ipython_config.py
   ln -s ../../dotfiles/.jupyter/lab/user-settings .jupyter/lab/user-settings
   mkdir -p .config/uv
   ln -s ../../dotfiles/.config/uv/uv.toml .config/uv/uv.toml
   ```

   Keep `~/.config/git` and `~/.config/shell` as real folders. Private files link into them. See
   [Private settings](#private-settings). k9s writes its own `config.yaml` and cluster state into
   `~/.config/k9s`, so that folder stays real too. Set the skin there, for example
   `k9s.ui.skin: catppuccin-frappe-transparent`. The uv installer keeps its receipt in `~/.config/uv`, so that
   folder stays real as well.

1. Link the shell files for your system.

   On macOS:

   ```bash
   ln -s dotfiles/.zshrc ~/.zshrc
   ln -s dotfiles/.zprofile ~/.zprofile
   ```

   On Linux:

   ```bash
   ln -s dotfiles/.bashrc ~/.bashrc
   ```

1. Start Neovim. `vim.pack` installs each plugin at the commit in `nvim-pack-lock.json`. Then install the
   language servers and the formatters:

   ```vim
   :MasonInstall clang-format clangd lua-language-server ruff rumdl shellcheck shfmt stylua ty
   ```

1. Install `jupytext`:

   ```bash
   uv tool install jupytext
   ```

1. Start tmux. On the first start, the config installs TPM and the tmux plugins.

## Private settings

Settings that name hosts, accounts, or work projects stay out of this repository. The public files load these
private files when they exist:

| Private file                 | Loaded by                     | Content                                     |
| ---------------------------- | ----------------------------- | ------------------------------------------- |
| `~/.config/shell/private.sh` | `.bashrc` and `.zshrc`        | Environment variables and shell functions.  |
| `~/.config/git/work`         | `.config/git/config`          | The default git name and email.             |
| `~/.ssh/config`              | `ssh`                         | Hosts and keys.                             |

Keys and tokens don't belong in these files either. Keep them in a password manager.

`.gitignore` lists `.config/git/work` and `.config/shell/private.sh`, so that a link inside this repository
can't add them by mistake.

## Git identity

Commits in `~/dotfiles` use the personal identity in `.config/git/personal`. The `includeIf` rule in
`.config/git/config` selects it. Every other repository uses the identity in `~/.config/git/work`.

## Neovim

- `lua/joonsuuh/plugins/` holds one file for each area, such as `lsp.lua` and `telescope.lua`.
- `lua/joonsuuh/pack.lua` holds the `vim.pack` helpers and the build steps for telescope-fzf-native and
  nvim-treesitter.
- To update the plugins, run `:lua vim.pack.update()`, read the changes, and then run `:write` to accept them.
  Commit `nvim-pack-lock.json` after an update.
- To check the setup, run `:checkhealth`.

### Language servers

| Language        | Servers           |
| --------------- | ----------------- |
| Python          | `ruff`, `ty`      |
| Lua             | `lua_ls`          |
| C, C++, CUDA    | `clangd`          |
| Markdown        | `rumdl`           |

- `ty` takes the repository root as the project root, so that imports resolve from the top of a large
  repository.
- In a git worktree that has no `.venv` folder, `ty` uses the `.venv` folder of the main checkout.

### Format

Press `<leader>f` to format the buffer. stylua formats Lua with the settings in `.config/nvim/.stylua.toml`.
ruff formats Python, and shfmt formats shell scripts. clang-format formats C++ and CUDA with the `.clang-format`
file of the project. It leaves the file as it is when the project has no `.clang-format`.

## License

MIT. See [LICENSE](LICENSE).

The k9s skins in `.config/k9s/skins/` come from [catppuccin/k9s](https://github.com/catppuccin/k9s), under the
MIT License. Copyright (c) 2021 Catppuccin.
