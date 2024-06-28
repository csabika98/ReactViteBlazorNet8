.PHONY: install

install:
	sudo apt-get update && sudo apt-get upgrade -y
	
	sudo apt-get install -y curl software-properties-common apt-transport-https
	
	curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
	sudo apt-get install -y nodejs

	wget https://packages.microsoft.com/config/ubuntu/$(shell lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
	sudo dpkg -i packages-microsoft-prod.deb
	sudo apt-get update
	
	sudo apt-get install -y dotnet-sdk-8.0
	
	rm packages-microsoft-prod.deb

	node --version
	dotnet --version