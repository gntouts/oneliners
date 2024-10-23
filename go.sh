#!/bin/bash
set -e

SUDOERS_FILE="/etc/sudoers.d/golang_secure_path"

if [ $# -eq 1 ]; then
    version=$1
else
    # If no parameter, perform actions to determine the latest version
    echo "No version parameter provided. Finding the latest release tag from the Go repository..."

    version=$(git ls-remote --tags https://go.googlesource.com/go | \
              grep -o 'refs/tags/go[0-9]*\.[0-9]*\.[0-9]*$' | \
              sed 's/refs\/tags\///' | \
              sort -V | \
              tail -n 1)

    # If version is still empty, exit with an error
    if [ -z "$version" ]; then
        echo "Error: Could not determine the latest version."
        exit 1
    fi
fi

echo "Downloading $version"
download_link="https://go.dev/dl/$version.linux-$(dpkg --print-architecture).tar.gz"
curl -sL -o go.tar.gz $download_link

echo "Removing existing Go installation"
sudo rm -rf /usr/local/go

echo "Unpacking go in /usr/local/go"
sudo tar -C /usr/local -xzf go.tar.gz

echo "Removing downloaded tar archive"
rm -fr go.tar.gz

echo "Adding go to PATH in /etc/profile"
sudo tee -a /etc/profile > /dev/null << 'EOT'
export PATH=$PATH:/usr/local/go/bin
EOT

echo "Adding Go path to secure_path for sudo users"
current_path=$(sudo grep -E '^Defaults\s+secure_path' /etc/sudoers | sed 's/^Defaults\s\+secure_path="\([^"]\+\)"/\1/')
if [ -z "$current_path" ]; then
    current_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
fi
GO_PATH="/usr/local/go/bin"

if [[ ":$current_path:" != *":$GO_PATH:"* ]]; then
    # Append the Go path to the current secure_path
    new_path="$current_path:$GO_PATH"

    # Write to the sudoers.d file
    echo "Defaults secure_path=\"$new_path\"" | sudo tee "$SUDOERS_FILE" > /dev/null

    # Set correct permissions for the sudoers.d file
    sudo chmod 0440 "$SUDOERS_FILE"

    echo "Go path added to secure_path."
else
    echo "Go path is already in secure_path."
fi
echo ""
echo "Success"