# DARWIN_MANAGES_HOME_MANAGER=false (デフォルトはtrue): home-manager/nixvimの
# 管理方法をflake評価時の環境変数で切り替える。ファイルは書き換えなくてよい。
#
# デフォルト(未設定 or true): darwinにhome-manager/nixvimを統合
#   nix run nix-darwin -- switch --flake .#ne0san --impure # 初回
#   sudo darwin-rebuild switch --flake ~/dotfiles#ne0san --impure # 二回目以降 (drsw)
#   ※このモードではhome-manager単体反映(hmsw)は無効化される
#
# DARWIN_MANAGES_HOME_MANAGER=false: home-manager/nixvimを単体で管理
#   DARWIN_MANAGES_HOME_MANAGER=false nix run home-manager/master -- switch --flake .#ne0san --impure -b backup # 初回
#   DARWIN_MANAGES_HOME_MANAGER=false home-manager switch --flake ~/dotfiles#ne0san --impure -b backup # 二回目以降 (hmsw)
#   ※このモードではdarwin-rebuild(drsw)は無効化される
#
# home-managerはmodule統合とstandaloneの併用が非対応で、同じプロファイルを
# 取り合って壊れる(darwin-rebuildのたびにhome-managerコマンドが消える等)ため、
# 必ずどちらか一方のモードに固定して使うこと。切り替えたときは、
# 上記のDARWIN_MANAGES_HOME_MANAGERを指定してこれから使う方のコマンドを
# 一度実行すれば、以降はnix/home.nixのdrsw/hmswエイリアスがそのモード用に
# 生成される(逆側のエイリアスは無効化メッセージに置き換わる)。

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
      # DARWIN_MANAGES_HOME_MANAGER環境変数でモードを切り替える(--impure必須)
      # 未設定 or "false"/"0"以外: home-managerをdarwinに統合(drswで一括反映、hmswは無効)
      # "false" または "0": home-managerを単体で管理(hmswで反映、drswは無効)
      darwinManagesHomeManager =
        let v = builtins.getEnv "DARWIN_MANAGES_HOME_MANAGER";
        in v != "false" && v != "0";
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
