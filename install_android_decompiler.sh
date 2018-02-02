#!/bin/bash -
#===============================================================================
#
#          FILE: install_android_decompiler.sh
#
#         USAGE: ./install_android_decompiler.sh
#
#   DESCRIPTION: 
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2018年01月31日 15时30分39秒
#      REVISION:  ---
#===============================================================================

set -o nounset                                  # Treat unset variables as an error

wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
mv apktool /usr/local/bin/apktool
chmod +x /usr/local/bin/apktool
wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.3.1.jar
mv apktool_2.3.1.jar /usr/local/bin/apktool.jar
chmox +x /usr/local/bin/apktool.jar


