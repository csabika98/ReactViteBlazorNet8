#!/bin/bash


set -e


sudo apt-get update && sudo apt-get upgrade -y


sudo apt-get install -y curl software-properties-common apt-transport-https wget


curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  


nvm install --lts
nvm use --lts


wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update


sudo apt-get install -y dotnet-sdk-8.0


rm packages-microsoft-prod.deb


node --version
dotnet --version
