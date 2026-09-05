# darwin (system設定 + home-manager + nixvim をまとめて反映)
#   nix run nix-darwin -- switch --flake .#ne0san --impure # 初回
#   sudo darwin-rebuild switch --flake ~/dotfiles#ne0san --impure # 二回目以降
# home-manager単体 (システム設定に触れず、dotfiles部分だけ反映)
#   nix run home-manager/master -- switch --flake .#ne0san # 初回
#   home-manager switch --flake ~/dotfiles#ne0san # 二回目以降
# nixvim単体 (nvim設定だけ素早く反映)
#   home-manager switch --flake ~/dotfiles#nixvim

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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nix-darwin, home-manager, nixvim, ... }:
    let
      system = "aarch64-darwin";
      username = builtins.getEnv "USER";
      # home.nixのunfreeパッケージ(1password-cli, claude-code)を
      # home-manager単体反映(homeConfigurations)でも許可するためのpkgs
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "1password-cli"
          "claude-code"
        ];
      };
    in {
      # darwin: システム設定(darwin.nix) + home-manager(home.nix, nixvim.nix)をまとめて反映
      darwinConfigurations."ne0san" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = { ... }:{
              imports = [
                nixvim.homeModules.nixvim
                ./nix/home.nix
                ./nix/nixvim.nix
              ];
            };
            home-manager.extraSpecialArgs = { inherit username; };
          }
        ];
        specialArgs = { inherit username; };
      };

      # home-manager: home.nix(dotfiles) + nixvim.nixをdarwinを介さず単体で反映
      homeConfigurations."ne0san" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit username; };
        modules = [
          nixvim.homeModules.nixvim
          ./nix/home.nix
          ./nix/nixvim.nix
        ];
      };

      # nixvim: nixvim.nixだけを単体で反映(nvim設定の素早いイテレーション用)
      homeConfigurations."nixvim" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit username; };
        modules = [
          nixvim.homeModules.nixvim
          ./nix/nixvim.nix
          {
            home.username = username;
            home.homeDirectory = "/Users/${username}";
            home.stateVersion = "25.05";
          }
        ];
      };
    };
}
