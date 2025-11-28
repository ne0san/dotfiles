# nix run home-manager/master -- switch --flake .#ne0san # 初回
# home-manager switch --flake ~/dotfiles/nix#ne0san # 二回目以降

{
  description = "ne0san's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations."ne0san" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;  # M系Mac
      modules = [ ./home.nix ];
    };
  };
}
