This is my personal dotfiles which contain config for vim, zsh, tmux, git, fzf etc;

## macOS setup
Set up by using [dotbot](https://blog.einverne.info/post/2020/08/use-dotbot-dotfiles-management.html):

    cd ~
    git clone git@github.com:einverne/dotfiles.git
	cd dotfiles
    # to bootstrap config for vim, zsh, tmux, git, fzf, etc
    make bootstrap
	# under Linux desktop, install essential packages
	make linux
	# under macOS, install applications by brew
	make mac
    ./install -c config/macos.conf.yaml

Log out and log in again, zinit will install all plugins automatically. If you use vi to edit file at first time, the vim-plug will install all vim plugins automatically.

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
- vim, using [vim-plug](https://github.com/junegunn/vim-plug) to manage vim plugins, vim-plug relate configuration is under `vim-plug_vimrc`. In Vim, `:PlugInstall` to install all vim plugins.
- tmux, using [tpm](https://blog.einverne.info/post/2017/12/tmux-plugins.html) to manage tmux plugins, in tmux, press `Ctrl +B` + `I` to install all tmux plugins.
- other useful tools, like [fzf](https://blog.einverne.info/post/2019/08/fzf-usage.html) to fuzzy search, ripgrep for recursively searching directories, zoxide to replace cd, exa to replace ls.

GUI applications:

- Kitty
- Karabiner-Elements
- Hammerspoon

### zsh config
to see `.zshrc` file.

### Vim config
vim-plug related configuration is under `vim-plug_vimrc`, to show all plugins list, use `:PluginList` in vim.

python related configurations is under `python_vimrc`.

## Components

- bin/: executable shell scripts, Anything in bin/ will get added to your $PATH and be made available everywhere.
- conf/: configuration file of zsh etc

## Instruction for vim

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
