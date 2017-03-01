This is my vim conf file.

vundle相关配置在vundle_vimrc中，用vundle管理插件，插件列表`:PluginList`查看
python相关配置在python_vimrc中

## Instruction under Linux

Just run `./install.sh`, everything is done. Then Enter the vim run `:PluginInstall` to install all plugins.

Or, you can do it manually follow the step:

Install Vundle to `~/.vim/` directory.

	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

Enter vim, run `:PluginInstall`, after install all plugin, you will meet an error,

> Taglist: Exuberant ctags (http://ctags.sf.net) not found in PATH. Plugin is not loaded.

I find a solution on [StackOverflow](http://stackoverflow.com/questions/7454796/taglist-exuberant-ctags-not-found-in-path)

For Ubuntu and derivatives:

	sudo apt-get install exuberant-ctags

with yum:

	sudo yum install ctags-etags

