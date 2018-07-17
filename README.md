vim, zsh, tmux 相关的配置

## Overview
使用 [antigen](https://gtk.pw/antigen) 来管理 zsh 插件

vundle 相关配置在 vundle_vimrc 中，用 vundle 管理插件，插件列表`:PluginList`查看

python 相关配置在 python_vimrc 中

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

## Plugin

	Plugin 'VundleVim/Vundle.vim'
	Plugin 'tpope/vim-fugitive'
	Plugin 'godlygeek/tabular'
	Plugin 'plasticboy/vim-markdown'
	Plugin 'scrooloose/nerdtree'
	Plugin 'davidhalter/jedi-vim'
	Plugin 'ervandew/supertab'
	Plugin 'Raimondi/delimitMate'
	Plugin 'tomasr/molokai'
	Plugin 'nathanaelkane/vim-indent-guides'
	Plugin 'vim-scripts/taglist.vim'
	Plugin 'WolfgangMehner/vim-plugins'
	Plugin 'L9'
	Plugin 'perl-support.vim'
	Plugin 'christoomey/vim-tmux-navigator'
	Plugin 'tpope/vim-surround'
	Plugin 'git://git.wincent.com/command-t.git'

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

