#!/bin/zsh

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# if [ "$(uname -m)" = "arm64" ] ; then
#   (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/${USER}/.zprofile
# eval "$(/opt/homebrew/bin/brew shellenv)"
# fi

# Install xcode
# Check if command line tools are installed
if ! xcode-select --print-path &> /dev/null; then
  # Install command line tools
  echo "Command line tools not found. Installing..."
  xcode-select --install
else
  echo "Command line tools are already installed."
fi

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install nix
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)