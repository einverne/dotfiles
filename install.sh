#!/bin/bash
VIMDIR=${1:-$HOME}

# install ctags to solve "Exuberant ctags not found in PATH" error
sudo apt-get install -y zsh zsh-antigen
chsh -s $(which zsh)
sudo apt-get install -y exuberant-ctags
sudo apt-get install -y vim vim-gtk tmux
sudo apt-get install htop tree zip wget

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


echo "start install, all of your old .vimrc and .vim will be overwritten."
echo "all your old vim settings will be mv to .vimrc.old & .vim.old"
echo -en "Do you want to continue?[y/n]"
read -n 1 use_vim_configs
if [ "$use_vim_configs" == "Y" ] || [ "$use_vim_configs" == "y" ]; then
	if [ -d "$VIMDIR/.vim" ]; then
		mv $VIMDIR/.vim $VIMDIR/.vim.old
		echo "origin .vim directory has been moved to .vim.old"
	fi
	if [ -f "$VIMDIR/.vimrc" ]; then
		mv $VIMDIR/.vimrc $VIMDIR/.vimrc.old
		echo "origin .vimrc has been moved to .vimrc.old"
	fi
	ln -rsf $PWD/.vim $VIMDIR/.vim 2> /dev/null
	ln -rsf $PWD/.vimrc $VIMDIR/.vimrc 2> /dev/null
    
	if [ -f "$VIMDIR/.tmux.conf" ]; then
		mv $VIMDIR/.tmux.conf $VIMDIR/.tmux.conf.old
		echo "origin .tmux.conf has been moved to .tmux.conf.old"
	fi
	ln -rsf $PWD/tmux/.tmux.conf $VIMDIR/.tmux.conf 2> /dev/null
	ln -rsf $PWD/tmux/.tmux.conf.local $VIMDIR/.tmux.conf.local 2> /dev/null

    # link zshrc
    ln -rsf $PWD/.zshrc $VIMDIR/.zshrc 2> /dev/null
fi

sudo apt-get install -y git
git submodule init && git submodule update

