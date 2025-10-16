#!/bin/zsh

# configディレクトリを作成
mkdir -p ~/.config/ghostty

# config/ghostty/configをリンク
ln -s "${SCRIPT_DIR}/.config/ghostty/config" ~/.config/ghostty/config"