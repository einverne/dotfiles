This is my vim dot file.

vundle相关配置在vundle_vimrc中，用vundle管理插件，插件列表`:PluginList`查看
python相关配置在python_vimrc中

## Instruction under windows
Windows下，在vim目录下

```
git init
git remote add origin https://github.com/einverne/dotfile.git
git fetch

git checkout -t origin/master
```

然后在vim目录下安装Vundle

	git clone https://github.com/gmarik/Vundle.vim.git vimfiles/bundle/Vundle.vim

进入vim，运行 `:PluginInstall` 安装剩余插件

将 https://github.com/tomasr/molokai 工程中的配色下载到 /vimfile/colors/ 目录下

将 ctags58.zip 压缩包中的 ctags.exe 解压到 vim74/ 目录下

## Instruction under Linux

Just run `./install.sh`, everything is done. Then Enter the vim run `:PluginInstall` to install all plugins.

Or, you can do it manually follow the step:

Install Vundle to `~/.vim/` directory.

	git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

Enter vim, run `:PluginInstall`, after install all plugin, you will meet an error,

> Taglist: Exuberant ctags (http://ctags.sf.net) not found in PATH. Plugin is not loaded.

I find a solution on [StackOverflow](http://stackoverflow.com/questions/7454796/taglist-exuberant-ctags-not-found-in-path)

For Ubuntu and derivatives:

	sudo apt-get install exuberant-ctags

with yum:

	sudo yum install ctags-etags

