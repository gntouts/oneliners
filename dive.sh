#!/bin/bash
set -e
echo "Checking latest version for https://github.com/wagoodman/dive..."
DIVE_VERSION=$(curl -L -s -o /dev/null -w '%{url_effective}' "https://github.com/wagoodman/dive/releases/latest" | grep -oP "v\d+\.\d+\.\d+" | sed 's/v//')
echo "Found latest version $DIVE_VERSION"
CPU_ARCH=$(dpkg --print-architecture)
echo "Downloading Debian package for dive v$DIVE_VERSION $CPU_ARCH"
curl -sL -o dive.deb https://github.com/wagoodman/dive/releases/download/v$DIVE_VERSION/dive_$DIVE_VERSION\_linux_$CPU_ARCH.deb

sudo echo "Installing package..."
sudo dpkg -i ./dive.deb

sudo apt-get install -f
rm -fr ./dive.deb
echo ""
echo "Success"