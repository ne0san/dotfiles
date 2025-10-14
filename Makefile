# Run all shell files
all: link brew zsh nix vscode astronvim test

# Create symbolic links
link:
	@echo "\033[0;34mRun link.sh\033[0m"
	@.bin/link.sh
	@echo "\033[0;32mDone.\033[0m"

# Install Homebrew and brew packages
brew:
	@echo "\033[0;34mRun brew.sh\033[0m"
	@brew/brew.sh
	@echo "\033[0;32mDone.\033[0m"

# Install Oh My Zsh and plugins
zsh:
	@echo "\033[0;34mRun zsh.sh\033[0m"
	@zsh/zsh.sh
	@echo "\033[0;32mDone.\033[0m"

# Install Nix and packages
nix:
	@echo "\033[0;34mRun nix.sh\033[0m"
	@nix/nix.sh
	@echo "\033[0;32mDone.\033[0m"

# Install VS Code
vscode:
	@echo "\033[0;34mInstall VS Code\033[0m"
	@echo "\033[0;32mDone.\033[0m"

# Install AstroNvim
astronvim:
	@echo "\033[0;34mRun astronvim.sh\033[0m"
	@astronvim/astronvim.sh
	@echo "\033[0;32mDone.\033[0m"

# Run test.sh to check installations
test:
	@echo "\033[0;34mRun test.sh\033[0m"
	@.bin/test.sh
	@echo "\033[0;32mDone.\033[0m"
