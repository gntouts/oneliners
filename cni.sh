#!/bin/bash
set -e

if [ $# -eq 1 ]; then
    version=$1
else
    # If no parameter, perform actions to determine the latest version
    echo "No version parameter provided. Finding the latest release tag from the CNI plugins repository..."

    version=$(git ls-remote --tags https://github.com/containernetworking/plugins.git | \
              grep -o 'refs/tags/v[0-9]*\.[0-9]*\.[0-9]*$' | \
              sed 's/refs\/tags\///' | \
              sed 's/v//' | \
              sort -V | \
              tail -n 1)

    # If version is still empty, exit with an error
    if [ -z "$version" ]; then
        echo "Error: Could not determine the latest version."
        exit 1
    fi
fi

echo "Downloading v$version"

download_link="https://github.com/containernetworking/plugins/releases/download/v$version/cni-plugins-linux-$(dpkg --print-architecture)-v$version.tgz"
curl -sL -o cni-plugins.tgz $download_link

echo "Unpacking CNI plugins in /opt/cni/bin"
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins.tgz

echo "Removing downloaded tar archive"
rm -fr cni-plugins.tgz

echo ""
echo "Success"