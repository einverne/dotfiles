#!/data/data/com.termux/files/usr/bin/bash

echo -e "Installing dependencies ..."
# https://github.com/4679/oh-my-termux
pkg install -y libcurl wget curl openssh vim git zsh unrar unzip less tree htop
pkg install -y tsu neofetch
echo -e "Successfully Installed"

if [ -d "$HOME/.termux" ]; then
    mv $HOME/.termux $HOME/.termux.bak
fi

if [ ! -d $HOME/.termux ]; then
    mkdir $HOME/.termux
fi

curl -fsLo $HOME/.termux/colors.properties --create-dirs https://github.com/einverne/dotfiles/raw/master/termux/colors.properties
curl -fsLo $HOME/.termux/termux.properties --create-dirs https://github.com/einverne/dotfiles/raw/master/termux/termux.properties
curl -fsLo $HOME/.termux/font.ttf --create-dirs https://github.com/einverne/dotfiles/raw/master/termux/font.ttf

git clone https://github.com/robbyrussell/oh-my-zsh $HOME/.oh-my-zsh --depth 1
cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' $HOME/.zshrc

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1
echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"

chsh -s zsh

termux-setup-storage
termux-reload-settings

echo "Done! "

exit
