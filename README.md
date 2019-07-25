dotfiles config contain vim, zsh, tmux configurations.

## Overview

- zsh
- vim
- tmux

With

- [antigen](https://gtk.pw/antigen) to manage zsh plugins, `source ~/.zshrc` to install all zsh plugins
- [vim-plug](https://github.com/junegunn/vim-plug) to manage vim plugins, vim-plug relate configuration is under `vim-plug_vimrc`. In Vim, `:PlugInstall` to install all vim plugins.
- [tpm](https://github.com/tmux-plugins/tpm) to manage tmux plugins, in tmux, press `Ctrl +B` + `I` to install all tmux plugins.

### zsh config
to see `.zshrc` file

### Vim config
vim-plug related configuration is under `vim-plug_vimrc`, to show all plugins list, use `:PluginList` in vim.

python related configurations is under `python_vimrc`.

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

