#!/bin/zsh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Install nix
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)

# configディレクトリを作成
mkdir -p ~/.config/nix

# config/nix/nix.confをリンク
ln -s "${SCRIPT_DIR}/.config/nix/nix.conf" ~/.config/nix/nix.conf

# nix profileでインストールするパッケージ一覧
packages=(
  "nixpkgs#devenv"
  "nixpkgs#direnv"
  "nixpkgs#nix-direnv"
)
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then \
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh && \
  nix --version; \
fi

# 全部インストール
for pkg in "${packages[@]}"; do
  nix profile add "$pkg"
done
