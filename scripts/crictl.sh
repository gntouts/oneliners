#!/bin/bash
set -e

CPU_ARCH=$(dpkg --print-architecture)

if [ $# -eq 1 ]; then
    VERSION=$1
else
    # If no parameter, perform actions to determine the latest version
    echo "No version parameter provided. Finding the latest release tag from the Github repository..."
    VERSION=$(git ls-remote --tags https://github.com/kubernetes-sigs/cri-tools | \
              grep -o 'refs/tags/v[0-9]*\.[0-9]*\.[0-9]*$' | \
                sed 's/refs\/tags\///' | \
                sort -V | \
                tail -n 1)
    # If version is still empty, exit with an error
    if [ -z "$VERSION" ]; then
        echo "Error: Could not determine the latest version."
        exit 1
    fi
fi

echo "Downloading release tarball for crictl $VERSION $CPU_ARCH"

download_link="https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-$CPU_ARCH.tar.gz"
curl -sL -o crictl.tar.gz $download_link

echo "Unpacking crictl in /usr/local/bin"
sudo tar zxf crictl.tar.gz -C /usr/local/bin

echo "Removing downloaded tar archive"
rm -fr crictl.tar.gz
echo ""
echo "Success"