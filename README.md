dotfiles config contain vim, zsh, tmux configurations.

## MacOS setup
Set up using dotbot:

    git clone git@github.com:einverne/dotfiles.git
	cd dotfiles
	# under Linux, install essential packages
	sh install.sh
	./install

## Overview

- using [dotbot](https://github.com/anishathalye/dotbot/) to manage dotfiles, [read more](https://blog.einverne.info/post/2020/08/use-dotbot-dotfiles-management.html)
- zsh, using [zinit](https://blog.einverne.info/post/2020/10/use-zinit-to-manage-zsh-plugins.html) as plugin management
- vim, using [vim-plug](https://github.com/junegunn/vim-plug) to manage vim plugins, vim-plug relate configuration is under `vim-plug_vimrc`. In Vim, `:PlugInstall` to install all vim plugins.
- tmux, using [tpm](https://blog.einverne.info/post/2017/12/tmux-plugins.html) to manage tmux plugins, in tmux, press `Ctrl +B` + `I` to install all tmux plugins.
- other useful tools, like [fzf](https://blog.einverne.info/post/2019/08/fzf-usage.html) to fuzzy search, ripgrep for recursively searching directories, zoxide to replace cd, exa to replace ls

### zsh config
to see `.zshrc` file

### Vim config
vim-plug related configuration is under `vim-plug_vimrc`, to show all plugins list, use `:PluginList` in vim.

python related configurations is under `python_vimrc`.

## Components

- bin/: executable shell scripts, Anything in bin/ will get added to your $PATH and be made available everywhere.
- conf/: configuration file of zsh etc

## Instruction under Linux

Just run `./install.sh`, everything is done. Then Enter the vim run `:PlugInstall` to install all plugins.

### install manually
Or, you can do it manually follow the step:

Enter vim, run `:PlugInstall`, after install all plugin, you will meet an error,

> Taglist: Exuberant ctags (http://ctags.sf.net) not found in PATH. Plugin is not loaded.

For Ubuntu and derivatives:

	sudo apt-get install exuberant-ctags

with yum:

	sudo yum install ctags-etags


## Tmux
Tmux 配置參考了 [gpakosz](https://github.com/gpakosz/.tmux) 的大部分配置。Tmux 的基础部分可以参考[这篇](http://einverne.github.io/post/2017/07/tmux-introduction.html) 文章。

需要满足

- `tmux >= 2.1`
- 在 tmux 运行的环境中，`$TERM` 需要设置为 `xterm-256color`

功能

- 在保留`C-b` 的前提下，`C-a` 作为第二选择
- `prefix + |` 开启垂直分割的新 panel， `prefix + -` 水平分割
- `C-hjkl` 直接在多 panel 中跳转
- Tmux 调整 Pane 窗口大小 `prefix + Shift + HJKL`

使用 Tmux Plugin Manager 管理，默认有如下插件

    set -g @plugin 'tmux-plugins/tpm'
    set -g @plugin 'tmux-plugins/tmux-sensible'
    set -g @plugin 'tmux-plugins/tmux-yank'


## fzf config
There are following alias in `.zshrc` :

- fe : open file using $EDITOR
- fo : open file Ctrl-o using open, Ctrl-e use $EDITOR
- fd : cd path
- fkill : kill process
- tm : tm new tmux session
- fs : tmux attach tmux session
