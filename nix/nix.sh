#!/usr/bin/zsh

# Install nix
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)

# nix profileでインストールするパッケージ一覧
packages=(
  "nixpkgs#devenv"
  "nixpkgs#direnv"
  "nixpkgs#nix-direnv"
)

# 全部インストール
for pkg in "${packages[@]}"; do
  nix profile add "$pkg"
done