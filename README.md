This is my vim conf file.

vundle相关配置在vundle_vimrc中，用vundle管理插件，插件列表`:PluginList`查看

python相关配置在python_vimrc中

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


