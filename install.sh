#!/bin/bash

set -e

sudo apt-get update && sudo apt-get upgrade -y


sudo apt-get install -y curl software-properties-common apt-transport-https wget


if [ -d "$HOME/.nvm" ]; then
    echo "Removing nvm..."
    rm -rf "$HOME/.nvm"
    sed -i '/NVM_DIR/d' $HOME/.bashrc
fi



curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs


sudo npm install -g n


sudo n lts


# sudo n latest
# sudo n 16.13.0


sudo npm cache clean -f
sudo n prune


node --version
npm --version


wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update


sudo apt-get install -y dotnet-sdk-8.0


rm packages-microsoft-prod.deb

dotnet --version

