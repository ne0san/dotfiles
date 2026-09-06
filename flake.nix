# darwin (システム設定のみ反映。home-manager/nixvimはここでは管理しない)
#   nix run nix-darwin -- switch --flake .#ne0san --impure # 初回
#   sudo darwin-rebuild switch --flake ~/dotfiles#ne0san --impure # 二回目以降
# home-manager (home.nix + nixvim.nixを反映)
#   nix run home-manager/master -- switch --flake .#ne0san -b backup # 初回
#   home-manager switch --flake ~/dotfiles#ne0san --impure -b backup # 二回目以降
#
# darwinConfigurationsにhome-manager.darwinModules.home-managerを混ぜてしまうと、
# darwin-rebuildとhome-manager単体反映が同じプロファイルを取り合って、
# darwin-rebuildのたびにhome-managerコマンドが消えるなどの不具合が起きる
# (home-managerのmodule統合とstandaloneの併用は非対応のため)。
# そのためdarwinはシステム設定専用にし、home-manager/nixvimはこちらのflake出力で
# 完全に独立して管理する。

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
    # nixvimは対応確認済みのnixpkgsに強くピン留めされているため、
    # follows で我々のnixpkgsに合わせず、nixvim自身の pin をそのまま使う
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = { nixpkgs, nix-darwin, home-manager, nixvim, ... }:
    let
      system = "aarch64-darwin";
      username = builtins.getEnv "USER";
      # home.nixのunfreeパッケージ(1password-cli, claude-code)を許可するpkgs
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "1password-cli"
          "claude-code"
        ];
      };
    in {
      # darwin: システム設定(darwin.nix)のみを反映
      darwinConfigurations."ne0san" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [ ./nix/darwin.nix ];
        specialArgs = { inherit username; };
      };

      # home-manager: home.nix(dotfiles) + nixvim.nixを反映
      homeConfigurations."ne0san" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit username; };
        modules = [
          nixvim.homeModules.nixvim
          ./nix/home.nix
          ./nix/nixvim.nix
        ];
      };
    };
}
