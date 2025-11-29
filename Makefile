# Run all shell files (GNU Make 3.81 compatible)
all: phase1 phase2 phase3 test

# Phase 1: Basic setup (parallel OK)
phase1: link xcode
	@echo "\033[0;32mPhase 1 completed.\033[0m"

# Phase 2: Development tools (after phase1, parallel OK)
phase2: phase1 brew zsh config
	@echo "\033[0;32mPhase 2 completed.\033[0m"

# Phase 3: Editors and terminal (after phase2, parallel OK)
phase3: phase2 nix astronvim ghostty
	@echo "\033[0;32mPhase 3 completed.\033[0m"

# Create symbolic links
link:
	@echo "\033[0;34mRun link.sh\033[0m"
	@.bin/link.sh
	@echo "\033[0;32mDone.\033[0m"

# Create symbolic link of ConfigFile
config:
	@echo "\033[0;34mRun config.sh\033[0m"
	@.config/config.sh
	@echo "\033[0;32mDone.\033[0m"

# Install Xcode
xcode:
	@echo "\033[0;34mRun xcode.sh\033[0m"
	@.bin/xcode.sh
	@echo "\033[0;32mDone.\033[0m"

# Install Homebrew and brew packages
brew:
	@echo "\033[0;34mRun brew.sh\033[0m"
	@.bin/brew.sh
	@echo "\033[0;32mDone.\033[0m"

# Install Oh My Zsh and plugins
zsh:
	@echo "\033[0;34mRun zsh.sh\033[0m"
	@zsh/zsh.sh
	@echo "\033[0;32mDone.\033[0m"

# Install Nix and packages and configure
nix:
	@echo "\033[0;34mRun nix.sh\033[0m"
	@nix/nix.sh
	@echo $$PATH
	@echo "\033[0;32mDone.\033[0m"

# Install AstroNvim
astronvim:
	@echo "\033[0;34mRun astronvim.sh\033[0m"
	@astronvim/astronvim.sh
	@echo "\033[0;32mDone.\033[0m"

# Run test.sh to check installations
test: 
	@echo "\033[0;34mRun test.sh\033[0m"
	@echo $$PATH
	@.bin/test.sh
	@echo "\033[0;32mDone.\033[0m"

.PHONY: all phase1 phase2 phase3 link xcode brew zsh nix config astronvim test
