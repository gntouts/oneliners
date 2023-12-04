#!/bin/bash
set -e
echo "Checking latest version for https://github.com/dbrgn/tealdeer..."
TLDR_VERSION=$(curl -L -s -o /dev/null -w '%{url_effective}' "https://github.com/dbrgn/tealdeer/releases/latest" | grep -oP "v\d+\.\d+\.\d+" | sed 's/v//')
echo "Found latest version $TLDR_VERSION"
arch=$(uname -m)

if [ "$arch" == "x86_64" ]; then
  CPU_ARCH="x86_64-musl"
elif [ "$arch" == "armv7l" ] || [ "$arch" == "aarch64" ]; then
  CPU_ARCH="arm-musleabi"
fi

echo "Downloading Debian package for tldr v$TLDR_VERSION $CPU_ARCH"
curl -L -o tldr https://github.com/dbrgn/tealdeer/releases/download/v$TLDR_VERSION/tealdeer-linux-$CPU_ARCH
sudo echo "Installing package..."
sudo install -m 755 tldr /usr/local/bin/

rm -fr ./tldr

echo ""
echo "Success"