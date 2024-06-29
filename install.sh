#!/bin/bash

#set -e

sudo apt-get install -y curl software-properties-common apt-transport-https wget


sudo rm -rf "$HOME/.nvm"
sudo rm -rf "$HOME/nvm"
sudo rm -rf ~/nvm
sudo rm -rf ~/.nvm
# For CodeSpace
sudo rm -rf /home/codespace/nvm/current/bin/node
sudo rm -rf /home/"$HOME"/nvm/current/bin/node
sudo rm -rf /home/codespace/nvm
sudo rm -rf /home/"$HOME"/nvm
sudo rm -rf /home/codespace/.nvm
sudo rm -rf /home/"$HOME"/.nvm

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs


sudo npm install -g n


sudo n lts



# sudo n latest
# sudo n 16.13.0


#sudo npm cache clean -f
#sudo n prune


node --version
npm --version


wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update


sudo apt-get install -y dotnet-sdk-8.0


rm packages-microsoft-prod.deb

dotnet --version



