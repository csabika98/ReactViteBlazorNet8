.PHONY: all install_homebrew install_nvm install_node add_to_profile install_dotnet

all: install_homebrew install_nvm add_to_profile install_node install_dotnet

install_homebrew:
	@echo "Checking for Homebrew..."
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Homebrew not found, installing..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@echo "Homebrew is installed"

install_nvm:
	@echo "Installing NVM using Homebrew..."
	@if ! brew list nvm >/dev/null 2>&1; then \
		brew install nvm; \
	fi
	@echo "NVM is installed"

add_to_profile:
	@echo "Adding NVM to profile"
	@echo 'export NVM_DIR="$$(brew --prefix nvm)"' >> ~/.zshrc
	@echo '[ -s "$$NVM_DIR/nvm.sh" ] && \. "$$NVM_DIR/nvm.sh"' >> ~/.zshrc
	@echo '[ -s "$$NVM_DIR/bash_completion" ] && \. "$$NVM_DIR/bash_completion"' >> ~/.zshrc

install_node: install_nvm add_to_profile
	@echo "Installing Node.js LTS"
	. "$$(brew --prefix nvm)/nvm.sh"; \
	nvm install --lts; \
	nvm use --lts

install_dotnet:
	@echo "Installing .NET 8.0"
	brew install dotnet@8