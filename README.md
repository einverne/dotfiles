This is my personal dotfiles which contain config for Neovim, vim, zsh, tmux, git, fzf etc.

Configuration files live in this repo and are symlinked into `$HOME` by [dotbot](https://github.com/anishathalye/dotbot/); the `Makefile` wraps every install/update command. Edit a file in the repo and the change takes effect immediately through the symlink — then commit and push to sync it to your other machines.

## macOS setup

Bootstrap a brand-new machine with [dotbot](https://blog.einverne.info/post/2020/08/use-dotbot-dotfiles-management.html):

```bash
cd ~
git clone git@github.com:einverne/dotfiles.git
cd dotfiles

make bootstrap   # create all symlinks (nvim, vim, zsh, tmux, git, fzf, ...)
make mac         # install GUI apps + CLI tools via brew (neovim, mise, ripgrep, fd, ...)
make macos       # apply macOS system defaults (optional)
```

Then finish the first-run steps:

- **Log out and log back in** — zinit installs all zsh plugins automatically.
- **Run `nvim` once** — [lazy.nvim](https://github.com/folke/lazy.nvim) bootstraps and installs every Neovim plugin; [Mason](https://github.com/mason-org/mason.nvim) installs the language server the first time you open a file of that type.
- **In tmux, press `Ctrl-b` + `I`** — [tpm](https://github.com/tmux-plugins/tpm) installs all tmux plugins.

Disable `.DS_Store` creation on network and USB volumes (also included in `macos/init_mac.sh`):

```bash
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
```

### Updating an existing machine

```bash
cd ~/dotfiles
git pull
make dotfiles    # rebuild symlinks (run after pulling new links, e.g. the nvim config)
# or
make update      # update everything, including submodules
```

### `make` command reference

Run `make help` to list every documented target.

| Command | What it does |
| --- | --- |
| `make bootstrap` | New-machine init: create symlinks + base bootstrap |
| `make dotfiles` | Rebuild symlinks only (run after editing `config/install.conf.yml`) |
| `make mac` | Install macOS apps and CLI tools via brew (includes `mise`) |
| `make brew` | Batch-install from `~/.Brewfile` via `brew bundle` (includes `mise`) |
| `make mise` | Install `mise` standalone (normally covered by the brew flow) |
| `make tmux` | Install non-brew tools such as the tmux plugin manager |
| `make macos` | Run the macOS system-defaults scripts |
| `make linux` / `make termux` | Provision a Linux / Termux environment |
| `make update` | Update everything |

## Termux setup
Install dependency first:

    pkg install make python vim git

then:

    git clone git@github.com:einverne/dotfiles.git
    cd dotfiles
    make termux

## Overview

- using [dotbot](https://github.com/anishathalye/dotbot/) to manage dotfiles, [read more](https://blog.einverne.info/post/2020/08/use-dotbot-dotfiles-management.html)
- zsh, using [zinit](https://blog.einverne.info/post/2020/10/use-zinit-to-manage-zsh-plugins.html) as zsh plugin management
- **Neovim**, the primary editor, using [lazy.nvim](https://github.com/folke/lazy.nvim) to manage plugins. Config lives under `.config/nvim/`. `vi` is aliased to `nvim` and `$EDITOR` is `nvim`. See the [Neovim config](#neovim-config) section below.
- vim (legacy), kept for compatibility and still driven by [vim-plug](https://github.com/junegunn/vim-plug). Run `vim` directly to use it; `:PlugInstall` installs its plugins.
- tmux, using [tpm](https://blog.einverne.info/post/2017/12/tmux-plugins.html) to manage tmux plugins, in tmux, press `Ctrl +B` + `I` to install all tmux plugins.
- [mise](https://mise.jdx.dev) to manage runtime versions (Python / Node / Flutter, ...), installed via brew.
- other useful tools, like [fzf](https://blog.einverne.info/post/2019/08/fzf-usage.html) to fuzzy search, ripgrep for recursively searching directories, zoxide to replace cd, exa to replace ls.

GUI applications:

- Karabiner-Elements
- Hammerspoon

Terminal font:

- Ghostty uses `Fira Code` as the primary terminal font, with `PingFang SC` as the Chinese fallback.
- Install the font on macOS with `brew install --cask font-fira-code`.

## Claude Code Support

This repository includes Claude Code skills and agents for enhanced AI assistance:

### Skills (.claude/skills/)
Specialized domain expertise that Claude can invoke:
- **git-workflow**: Git operations and best practices
- **shell-scripting**: Bash/Zsh scripting and automation
- **dotfiles-manager**: Dotfiles organization and management
- **debug-helper**: Debugging and troubleshooting
- **performance-optimizer**: Code and script optimization
- **test-expert**: Testing and TDD practices

See [.claude/skills/README.md](.claude/skills/README.md) for detailed usage.

### Agents (claude/agents/)
Autonomous task execution specialists:
- **code-reviewer**: Comprehensive code review
- **backend-architect**: Backend design and architecture
- **frontend-developer**: Frontend development
- **typescript-pro**: TypeScript expertise
- **flutter-expert**: Flutter development
- **ui-ux-designer**: UI/UX design guidance

### zsh config
to see `.zshrc` file.

### Neovim config

Neovim is the primary editor. Its config is a modular Lua setup under `.config/nvim/`, symlinked to `~/.config/nvim` and managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

```
.config/nvim/
├── init.lua                 # entry: leader → options → keymaps → autocmds → lazy
├── lua/config/              # options, keymaps, autocmds, lazy bootstrap
└── lua/plugins/             # one file per plugin group
```

- First launch installs every plugin automatically; language servers are installed on demand by [Mason](https://github.com/mason-org/mason.nvim).
- Requires a [Nerd Font](https://www.nerdfonts.com/) terminal font plus `ripgrep` and `fd` (all in the brew install) for icons and Telescope search.
- Manage things in-editor with `:Lazy` (plugins), `:Mason` (language servers) and `:checkhealth`.
- Leader key is `,`. See `.config/nvim/README.md` for the full keymap table and the Vim→Neovim plugin mapping.

### Vim config (legacy)

The original Vim setup is kept for compatibility — run `vim` directly to use it (`vi` is aliased to `nvim`). vim-plug related configuration is under `vim-plug_vimrc`, to show all plugins list, use `:PluginList` in vim. Python related configurations are under `python_vimrc`.

## Components

- bin/: executable shell scripts, Anything in bin/ will get added to your $PATH and be made available everywhere.
- conf/: configuration file of zsh etc

## Instruction for vim (legacy)

> Neovim is the primary editor (see [Neovim config](#neovim-config)). The steps below apply only to the legacy `vim`.

Enter the vim and then run `:PlugInstall` to install all plugins.

### install manually
Or, you can do it manually follow the step:

Enter vim, run `:PlugInstall`, after install all plugin, you will meet an error,

> Taglist: Exuberant ctags (http://ctags.sf.net) not found in PATH. Plugin is not loaded.

For Ubuntu and derivatives:

    sudo apt-get install exuberant-ctags

with yum:

    sudo yum install ctags-etags

## Tmux config
I take some Tmux config from [gpakosz](https://github.com/gpakosz/.tmux). If you want to learn more about tmux, you can check [this article](http://einverne.github.io/post/2017/07/tmux-introduction.html).

You can manually install tmux plugins by `prefix + I`.

Tmux need：

- `tmux >= 2.1`
- You should set `$TERM` environment for `xterm-256color`

Tmux config:

- You can use `C-b` as prefix, and use `C-a` as second choice
- `prefix + |` to split panel vertically， `prefix + -` split panel horizontally
- `C-hjkl` to switch pane
- `prefix + Shift + HJKL` to adjust pane size

Copy mode:

- Enter copy mode with `prefix + [`
- Use `Space` to start selection, then `Enter` to copy
- In vi mode, use `v` to start selection, then `y` to copy
- You can also drag with the mouse, and copy on mouse release
- Local sessions prefer the system clipboard directly; remote SSH sessions fall back to OSC 52 so copied text can reach the outer terminal clipboard
- See `tmux/OSC52_CLIPBOARD.md` for more details about the remote clipboard setup

I use Tmux Plugin Manager to manage tmux plugins, and by default I use following plugins:

    set -g @plugin 'tmux-plugins/tpm'
    set -g @plugin 'tmux-plugins/tmux-sensible'
    set -g @plugin 'tmux-plugins/tmux-yank'
    set -g @plugin 'tmux-plugins/tmux-resurrect'
    set -g @plugin 'tmux-plugins/tmux-continuum'
    set -g @plugin 'tmux-plugins/tmux-open'
    set -g @plugin 'tmux-plugins/tmux-copycat'

## fzf config
There are following alias in `.zshrc` :

- fe : open file using $EDITOR
- fo : open file Ctrl-o using open, Ctrl-e use $EDITOR
- fcd : cd path  (fd to replace find)
- fkill : kill process
- tm : tm new tmux session
- fs : tmux attach tmux session

## karabiner config

Karabiner-Elements configuration uses a hybrid approach since [Goku](https://github.com/yqrashawn/GokuRakuJoudo) does not support `keyboard_type_if` conditions needed for JIS keyboard remapping.

### File structure

- `karabiner.edn` - Goku source file for non-JIS rules (caps lock, ctrl+n/p, app-specific shortcuts, simlayers, etc.)
- `jis-rules.json` - JIS keyboard layout remapping rules (20 rules, requires `keyboard_type_if` which Goku cannot express)
- `merge-karabiner.sh` - Script to merge Goku-generated config with JIS rules

### Usage

```bash
# 1. After editing karabiner.edn, run goku to generate base config
goku

# 2. Merge JIS rules into the generated config
./karabiner/merge-karabiner.sh
```

### JIS rules overview

The JIS rules remap a Japanese keyboard layout to produce US ANSI characters. Key mappings include `@` to `[`, `[` to `]`, `^` to `=`, `:` to `'`, `¥` to `` ` ``, and their shifted variants.

The shift+bracket rules (`shift+@ → {`, `shift+[ → }`) intentionally exclude `command` from optional modifiers so that `Cmd+Shift+[` / `Cmd+Shift+]` pass through as raw keycodes for native tab switching in apps like Ghostty.
