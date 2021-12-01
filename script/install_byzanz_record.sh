#!/bin/bash - 

# take from http://askubuntu.com/questions/107726/how-to-create-animated-gif-images-of-a-screencast
sudo apt-get install -y byzanz

# example
# byzanz-record --duration=15 --x=200 --y=300 --width=700 --height=400 out.gif

# install automake tool to avoid "autoreconf: not found" error
# use the following command to install automake tool
sudo apt-get install -y autoconf automake libtool build-essential checkinstall libx11-dev x11-utils

git clone https://github.com/lolilolicon/xrectsel.git && cd xrectsel 
./bootstrap && ./configure --prefix /usr && make && sudo make install
cd .. && rm -rf xrectsel

# 1. byzanz-record-window - To select a window for recording.
# 2. byzanz-record-region - To select a part of the screen for recording.
# 3. A simple GUI front-end for 1, by MHC.
