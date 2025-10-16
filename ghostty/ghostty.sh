#!/bin/zsh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# configディレクトリを作成
mkdir -p ~/.config/ghostty

# config/ghostty/configをリンク
ln -s "${SCRIPT_DIR}/.config/ghostty/config" ~/.config/ghostty/config