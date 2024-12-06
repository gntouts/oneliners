#!/bin/bash
set -e

if [ $# -eq 1 ]; then
    version=$1
else
    # If no parameter, perform actions to determine the latest version
    echo "No version parameter provided. Finding the latest release tag from the containerd repository..."

    version=$(git ls-remote --tags https://github.com/containerd/containerd.git | \
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

download_link="https://github.com/containerd/containerd/releases/download/v$version/containerd-$version-linux-$(dpkg --print-architecture).tar.gz"
curl -sL -o containerd.tar.gz $download_link

echo "Unpacking containerd in /usr/local/"
sudo tar Cxzf /usr/local containerd.tar.gz

echo "Removing downloaded tar archive"
rm -fr containerd.tar.gz

echo "Installing containerd service under /usr/local/lib/systemd/system/"
download_link="https://raw.githubusercontent.com/containerd/containerd/v$version/containerd.service"
curl -sL -o containerd.service $download_link
sudo mkdir -p /usr/local/lib/systemd/system/
sudo mv containerd.service /usr/local/lib/systemd/system/containerd.service
sudo chown root:root /usr/local/lib/systemd/system/containerd.service

echo "Enabling containerd service"
sudo systemctl daemon-reload
sudo systemctl enable --now containerd.service

echo "Creating default configuration file"
sudo mkdir -p /etc/containerd/

if [ -f /etc/containerd/config.toml ]; then
    echo "/etc/containerd/config.toml already exists. Creating backup."
    sudo mv /etc/containerd/config.toml /etc/containerd/config.toml.bak
fi

if sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null; then
    echo "Configuration file created successfully."
else
    echo "Failed to create configuration file." >&2
    exit 1
fi

echo ""
echo "Success"