#!/bin/zsh

# Check operating system
if [ "$(uname)" != "Darwin" ] ; then
	echo "Not macOS!"
	exit 1
fi

brew bundle --global