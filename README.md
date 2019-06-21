dotfiles config contain vim, zsh, tmux configurations.

## Overview

- zsh
- vim
- tmux

With

- [Vundle](https://github.com/VundleVim/Vundle.vim) to manage vim plugins, vundle relate configuration is under `vundle_vimrc`
- [antigen](https://gtk.pw/antigen) to manage zsh plugins
- [tpm](https://github.com/tmux-plugins/tpm) to manage tmux plugins


### Vim config
vundle related configuration is under `vundle_vimrc`, to show all plugins list, use `:PluginList` in vim.

python related configurations is under `python_vimrc`.



## Instruction under Linux

Just run `./install.sh`, everything is done. Then Enter the vim run `:PluginInstall` to install all plugins.

### install manually
Or, you can do it manually follow the step:

1. Install Vundle to `~/.vim/` directory.

	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

2. Enter vim, run `:PluginInstall`, after install all plugin, you will meet an error,

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

使用 Tmux Plugin Manager 管理，默认有如下插件

    set -g @plugin 'tmux-plugins/tpm'
    set -g @plugin 'tmux-plugins/tmux-sensible'
    set -g @plugin 'tmux-plugins/tmux-yank'

