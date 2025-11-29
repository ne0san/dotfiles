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

# nix-darwin build
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
sudo USER=$USER nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ~/dotfiles/nix#ne0san --impure
