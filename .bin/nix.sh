#!/usr/bin/zsh

# nix profileでインストールするパッケージ一覧
packages=(
  "nixpkgs#devenv"
  "nixpkgs#direnv"
  "nixpkgs#nix-direnv"
)

# 全部インストール
for pkg in "${packages[@]}"; do
  nix profile install "$pkg"
done