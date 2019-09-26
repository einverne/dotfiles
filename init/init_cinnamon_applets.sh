#!/bin/bash -

set -o nounset                                  # Treat unset variables as an error

DESKTOP_CAPTURE=v1.17

# desktop capture
sudo apt install -y byzanz

TEMP_FORLDER=capture
wget https://github.com/rjanja/desktop-capture/archive/${DESKTOP_CAPTURE}.tar.gz
mkdir -p ${TEMP_FORLDER}
tar xzvf ${DESKTOP_CAPTURE}.tar.gz -C ${TEMP_FORLDER}
mv -v ${TEMP_FORLDER}/capture@rjanja ~/.local/share/cinnamon/applets/
rm -rf ${DESKTOP_CAPTURE}.tar.gz
rm -rf ${TEMP_FORLDER}
