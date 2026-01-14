# Run all shell files (GNU Make 3.81 compatible)
all: phase1 phase2 phase3 test

# Phase 1: Basic setup (parallel OK)
phase1: xcode
	@echo "\033[0;32mPhase 1 completed.\033[0m"

# Phase 2: Development tools (after phase1, parallel OK)
phase2: phase1 brew
	@echo "\033[0;32mPhase 2 completed.\033[0m"

# Phase 3: Editors and terminal (after phase2, parallel OK)
phase3: phase2 nix
	@echo "\033[0;32mPhase 3 completed.\033[0m"

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

# Install Nix and packages and configure
nix:
	@echo "\033[0;34mRun nix.sh\033[0m"
	@nix/nix.sh
	@echo $$PATH
	@echo "\033[0;32mDone.\033[0m"

.PHONY: all phase1 phase2 phase3 xcode brew nix
