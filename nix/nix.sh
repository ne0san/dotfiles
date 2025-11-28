#!/bin/zsh

# Install nix
# GitHub Actionsで既にNixがインストールされてる場合はスキップ
if [[ "${NIX_SKIP_INSTALL}" == "true" ]]; then
  echo "Nix installation skipped (already installed)"
else
  echo "Installing Nix..."
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
fi

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh 

# TODO flakeの適用
