#!/bin/bash -
#===============================================================================
#
#          FILE: ubuntu_init.sh
#
#         USAGE: ./ubuntu_init.sh
#
#   DESCRIPTION: 
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 08/30/2019 03:21:28 PM
#      REVISION:  ---
#===============================================================================

set -o nounset                                  # Treat unset variables as an error


sudo apt install -y vim \
	exuberant-ctags \
	fcitx \
	fcitx-rime \
	fcitx-module-cloudpinyin \
	gimp \
	inkscape \
	shutter \
	audacity \
	numix-gtk-theme \
	numix-icon* \
	ultra-flat-icons-* \
	ultra-flat-icons \
	uget \
	telegram \
	fonts-emojione-svginot
