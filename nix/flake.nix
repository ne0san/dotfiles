# nix run home-manager/master -- switch --flake .#ne0san # 初回
# home-manager switch --flake ~/dotfiles/nix#ne0san # 二回目以降

{
  description = "ne0san's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nix-darwin, home-manager, ... }: 
    # nix-darwin configuration
    let
      username = builtins.getEnv "USER";
    in {
      darwinConfigurations."ne0san" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit username; };
          }
        ];
        specialArgs = { inherit username; };
      };
    };
  
}
