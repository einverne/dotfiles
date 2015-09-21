#!/bin/bash
VIMDIR=${1:-$HOME}

echo "start install, all of your old .vimrc and .vim will be overwritten."
echo "all your old vim settings will be mv to .vimrc.old & .vim.old"
echo -en "Do you want to continue?[y/n]"
read -n 1 use_vim_configs
if [ "$use_vim_configs" == "Y" ] || [ "$use_vim_configs" == "y" ]; then
	mv $VIMDIR/.vim $VIMDIR/.vim.old
	mv $VIMDIR/.vimrc $VIMDIR/.vimrc.old
	ln -s $PWD/.vim $VIMDIR/.vim 2> /dev/null
	cat $PWD/_vimrc > $PWD/.vimrc
	ln -s $PWD/.vimrc $VIMDIR/.vimrc 2> /dev/null
fi

git submodule init && git submodule update
