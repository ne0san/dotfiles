#!/bin/zsh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Install nix
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)

# nix profileでインストールするパッケージ一覧
packages=(
  "nixpkgs#devenv"
  "nixpkgs#direnv"
  "nixpkgs#nix-direnv"
)

. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'

# 全部インストール
for pkg in "${packages[@]}"; do
  nix profile add "$pkg"
done

# configディレクトリを作成
mkdir -p ~/.config/nix

# config/nix/nix.confをリンク
ln -s "${SCRIPT_DIR}/.config/nix/nix.conf" ~/.config/nix/nix.conf