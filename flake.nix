# darwinManagesHomeManager = true (デフォルト): darwinにhome-manager/nixvimを統合
#   nix run nix-darwin -- switch --flake .#ne0san --impure # 初回
#   sudo darwin-rebuild switch --flake ~/dotfiles#ne0san --impure # 二回目以降 (drsw)
#   ※このモードではhome-manager単体反映(hmsw)は無効化される
#
# darwinManagesHomeManager = false: home-manager/nixvimを単体で管理
#   nix run home-manager/master -- switch --flake .#ne0san -b backup # 初回
#   home-manager switch --flake ~/dotfiles#ne0san --impure -b backup # 二回目以降 (hmsw)
#   ※このモードではdarwin-rebuild(drsw)は無効化される
#
# home-managerはmodule統合とstandaloneの併用が非対応で、同じプロファイルを
# 取り合って壊れる(darwin-rebuildのたびにhome-managerコマンドが消える等)ため、
# 下のdarwinManagesHomeManagerで必ずどちらか一方のモードに固定する。
# 切り替えたときは、これから使う方のコマンドを一度実行してから
# nix/home.nixのdrsw/hmswエイリアスを使うこと。

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
      lib = nixpkgs.lib;
      system = "aarch64-darwin";
      username = builtins.getEnv "USER";
      # true: home-managerをdarwinに統合して管理(drswで一括反映、hmswは無効)
      # false: home-managerを単体で管理(hmswで反映、drswは無効)
      darwinManagesHomeManager = true;
      # home.nixのunfreeパッケージ(1password-cli, claude-code)を許可するpkgs
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
          "1password-cli"
          "claude-code"
        ];
      };
    in {
      # darwin: システム設定(darwin.nix)を反映
      # darwinManagesHomeManager = true のときはhome-manager(home.nix, nixvim.nix)も
      # まとめて反映する
      darwinConfigurations."ne0san" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [ ./nix/darwin.nix ] ++ lib.optionals darwinManagesHomeManager [
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
            home-manager.extraSpecialArgs = { inherit username darwinManagesHomeManager; };
          }
        ];
        specialArgs = { inherit username darwinManagesHomeManager; };
      };

      # home-manager: home.nix(dotfiles) + nixvim.nixを単体で反映
      # (darwinManagesHomeManager = false のときに使う)
      homeConfigurations."ne0san" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit username darwinManagesHomeManager; };
        modules = [
          nixvim.homeModules.nixvim
          ./nix/home.nix
          ./nix/nixvim.nix
        ];
      };
    };
}
