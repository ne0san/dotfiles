# darwin (システム設定 + home-manager/nixvimを統合して反映)
#   nix run nix-darwin -- switch --flake .#ne0san --impure # 初回
#   sudo darwin-rebuild switch --flake ~/dotfiles#ne0san --impure # 二回目以降 (drsw)
#
# home-manager単体 (home.nix + nixvim.nixだけを反映。darwin/linux両対応、
# 実行ホストのsystemを自動判定するため同じコマンドでOK)
#   nix run home-manager/master -- switch --flake .#ne0san --impure -b backup # 初回
#   home-manager switch --flake ~/dotfiles#ne0san --impure -b backup # 二回目以降 (hmsw)
#

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
      unfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
        "1password-cli"
        "claude-code"
      ];
      # home-manager単体は、既にUSER取得で--impure運用な点を踏まえ、
      # 評価を実行したホストのsystemをそのまま使う(darwin/linux, アーキ問わず自動対応)。
      # そのためnix flake show/checkのような「今いないホスト」向けの静的な確認はできない。
      homePkgs = import nixpkgs {
        system = builtins.currentSystem;
        config.allowUnfreePredicate = unfreePredicate;
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
                ./nix/nixvim
              ];
            };
            # darwin統合モード: home.nix側でhmswを無効化させる
            home-manager.extraSpecialArgs = { inherit username; darwinManagesHomeManager = true; };
          }
        ];
        specialArgs = { inherit username; };
      };

      # home-manager: home.nix(dotfiles) + nixvim.nixをdarwinを介さず単体で反映
      # systemは実行ホストのcurrentSystemに従うため、darwin/linux・アーキ問わず同じ
      # 出力名(ne0san)のまま使える(--impure必須。元々USER取得で必須だったので実質変化なし)
      homeConfigurations."ne0san" = home-manager.lib.homeManagerConfiguration {
        pkgs = homePkgs;
        # home-manager単体モード: home.nix側でdrswを無効化させる
        extraSpecialArgs = { inherit username; darwinManagesHomeManager = false; };
        modules = [
          nixvim.homeModules.nixvim
          ./nix/home.nix
          ./nix/nixvim
        ];
      };
    };
}
