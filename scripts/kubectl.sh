set -e

if [ $# -eq 1 ]; then
    version=$1
else
    # If no parameter, perform actions to determine the latest version
    echo "No version parameter provided. Finding the latest kubectl release..."
    version=$(curl -L -s https://dl.k8s.io/release/stable.txt | sed 's/v//')
    
    # If version is still empty, exit with an error
    if [ -z "$version" ]; then
        echo "Error: Could not determine the latest version."
        exit 1
    fi
fi

echo "Downloading v$version"

download_link="https://dl.k8s.io/release/v$version/bin/linux/$(dpkg --print-architecture)/kubectl"
curl -sL -o kubectl $download_link

echo "Installing kubectl v$version"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "Cleaning up"
rm -fr kubectl

echo ""
echo "Success"