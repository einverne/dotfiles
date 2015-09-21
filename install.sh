#!/bin/bash
VIMDIR=${1:-$HOME}

mv $VIMDIR/.vim $VIMDIR/.vim.old
mv $VIMDIR/.vimrc $VIMDIR/.vimrc.old
ln -s $PWD/.vim $VIMDIR/.vim 2> /dev/null
cat $PWD/_vimrc > $PWD/.vimrc
ln -s $PWD/.vimrc $VIMDIR/.vimrc 2> /dev/null

git submodule init && git submodule update
