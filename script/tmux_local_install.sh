#!/bin/bash -

# https://gist.github.com/ryin/3106801

# Script for installing tmux on systems where you don't have root access.
# tmux will be installed in $HOME/local/bin.
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e

TMUX_VERSION=2.9a
LIBEVENT_VERSION=2.1.8-stable
NCURSES_VERSION=6.1

# create our directories
mkdir -p $HOME/local $HOME/tmux_tmp
cd $HOME/tmux_tmp

# download source files for tmux, libevent, and ncurses
wget https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
wget https://github.com/libevent/libevent/releases/download/release-${LIBEVENT_VERSION}/libevent-${LIBEVENT_VERSION}.tar.gz 
wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz 

# extract files, configure, and compile

############
# libevent #
############
#tar xvzf libevent-${LIBEVENT_VERSION}.tar.gz
#cd libevent-${LIBEVENT_VERSION}
#./configure --prefix=$HOME/local --disable-shared
#make
#make install
#cd ..
#
#############
## ncurses  #
#############
#tar xvzf ncurses-${NCURSES_VERSION}.tar.gz
#cd ncurses-${NCURSES_VERSION}
#./configure --prefix=$HOME/local
#make
#make install
#cd ..
#
#############
## tmux     #
#############
#tar xvzf tmux-${TMUX_VERSION}.tar.gz
#cd tmux-${TMUX_VERSION}
#./configure CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include"
#CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib" make
#cp tmux $HOME/local/bin
#
#cd $HOME
#
## cleanup
#rm -rf $HOME/tmux_tmp
#
#echo "$HOME/local/bin/tmux is now available. You can optionally add $HOME/local/bin to your PATH."
#
## for the in order to add to the .bashrc (for /sh/bash) comment-in below line
#echo 'export PATH="$HOME/local/bin:$PATH"' >> $HOME/.bashrc
