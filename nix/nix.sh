#!/usr/bin/zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

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

# configディレクトリを作成
mkdir -p ~/.config/nix

# config/nix/nix.confをリンク
ln -s "${SCRIPT_DIR}/.config/nix/nix.conf" ~/.config/nix/nix.conf