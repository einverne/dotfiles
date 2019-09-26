#!/bin/bash -

set -o nounset                                  # Treat unset variables as an error

VIM_SERVER="https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc"
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "Are you sure to install vim for server"
read -n 1 is_server
if [ "$is_server" == "Y" ] || [ "$is_server" == "y" ]; then
    curl $VIM_SERVER > $HOME/.vimrc
    exit
fi

