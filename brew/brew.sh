#!/bin/zsh

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# if [ "$(uname -m)" = "arm64" ] ; then
#   (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/${USER}/.zprofile
# eval "$(/opt/homebrew/bin/brew shellenv)"
# fi

# Check operating system
if [ "$(uname)" != "Darwin" ] ; then
	echo "Not macOS!"
	exit 1
fi

brew bundle --global