#!/bin/bash
set -e

if [ $# -eq 1 ]; then
    version=$1
else
    # If no parameter, perform actions to determine the latest version
    echo "No version parameter provided. Finding the latest release tag from the CNI plugins repository..."

    version=$(git ls-remote --tags https://github.com/opencontainers/runc.git | \
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
download_link="https://github.com/opencontainers/runc/releases/download/v$version/runc.$(dpkg --print-architecture)"
curl -sL -o runc $download_link

echo "Installing v$version"
sudo install -m 755 runc /usr/local/sbin/runc

echo "Cleaning up"
rm -fr runc

echo ""
echo "Success"
