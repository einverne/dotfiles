#!/bin/bash
VIMDIR=${1:-$HOME}

# install ctags to solve "Exuberant ctags not found in PATH" error
sudo apt-get install -y git zsh zsh-antigen vim vim-gtk tmux
chsh -s $(which zsh)
sudo apt-get install -y exuberant-ctags
sudo apt-get install -y sudo apt-get install htop tree zip unzip wget nethogs

VIM_SERVER="https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc"
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
read -n 1 is_server
if [ "$is_server" == "Y" ] || [ "$is_server" == "y" ]; then
    curl $VIM_SERVER > $HOME/.vimrc
    exit
fi

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
    curl -L git.io/antigen > $VIMDIR/antigen.zsh
fi

git submodule init && git submodule update

