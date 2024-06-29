.PHONY: all install_homebrew install_node install_dotnet

all: install_homebrew install_node install_dotnet

install_homebrew:
	@echo "Checking for Homebrew..."
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Homebrew not found, installing..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@echo "Homebrew is installed"

install_node: 
	@echo "Installing Node.js LTS"
	brew install node@20
	brew link --overwrite node@20
	brew unlink node@20 && brew link --force node@20

install_dotnet:
	@echo "Installing .NET 8.0"
	brew install dotnet@8
