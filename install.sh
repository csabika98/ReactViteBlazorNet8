#!/bin/bash


set -e


sudo apt-get update && sudo apt-get upgrade -y


sudo apt-get install -y curl software-properties-common apt-transport-https wget


if [ -d "$HOME/.nvm" ]; then
    echo "nvm is already installed. Skipping the installation step."
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi


export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"  
fi
if [ -s "$NVM_DIR/bash_completion" ]; then
    . "$NVM_DIR/bash_completion"  
fi


command -v nvm >/dev/null 2>&1 || { echo >&2 "NVM is not available. Please log out and back in or source your profile."; exit 1; }


nvm install --lts
nvm use --lts


wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update


sudo apt-get install -y dotnet-sdk-8.0


rm packages-microsoft-prod.deb

node --version
dotnet --version

