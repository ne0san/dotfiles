#!/bin/zsh

echo "Checking required installations..."
echo ""

# Track if all checks pass
all_passed=true

# Check Homebrew
echo -n "Checking Homebrew... "
if command -v brew &> /dev/null; then
    echo " Installed ($(brew --version | head -n1))"
else
    echo " Not installed"
    all_passed=false
fi

# Check Oh My Zsh
echo -n "Checking Oh My Zsh... "
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo " Installed"
else
    echo " Not installed"
    all_passed=false
fi

# Check Nix
source "/etc/zshrc"
echo -n "Checking Nix... "
if command -v nix &> /dev/null; then
    echo " Installed ($(nix --version))"
else
    echo " Not installed"
    all_passed=false
fi

# Check direnv
echo -n "Checking direnv... "
if command -v direnv &> /dev/null; then
    echo " Installed ($(direnv --version))"
else
    echo " Not installed"
    all_passed=false
fi

# Check VS Code
echo -n "Checking VS Code... "
if command -v code &> /dev/null; then
    echo " Installed ($(code --version | head -n1))"
else
    echo " Not installed"
    all_passed=false
fi

# Summary
echo ""
if [ "$all_passed" = true ]; then
    echo "All checks passed!"
    exit 0
else
    echo "Some installations are missing. Please install the missing components."
    exit 1
fi
