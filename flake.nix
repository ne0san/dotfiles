# darwin (システム設定 + home-manager/nixvimを統合して反映)
#   nix run nix-darwin -- switch --flake .#ne0san --impure # 初回
#   sudo darwin-rebuild switch --flake ~/dotfiles#ne0san --impure # 二回目以降 (drsw)
#
# home-manager単体 (home.nix + nixvim.nixだけを反映、macOS向け)
#   nix run home-manager/master -- switch --flake .#ne0san --impure -b backup # 初回
#   home-manager switch --flake ~/dotfiles#ne0san --impure -b backup # 二回目以降 (hmsw)
#
# home-manager単体 (home.nix + nixvim.nixだけを反映、Linux向け)
# アーキテクチャに応じて ne0san-linux-x86_64 / ne0san-linux-aarch64 を使い分ける
#   nix run home-manager/master -- switch --flake .#ne0san-linux-x86_64 --impure -b backup # 初回
#   home-manager switch --flake ~/dotfiles#ne0san-linux-x86_64 --impure -b backup # 二回目以降 (hmsw)
#
# home-managerはmodule統合とstandaloneの併用が非対応で、同じプロファイルを
# 取り合って壊れる(darwin-rebuildのたびにhome-managerコマンドが消える等)ため、
# 直近に反映した方だけが安全に使えるモードになる。
# darwinConfigurations/homeConfigurationsそれぞれがhome.nixにdarwinManagesHomeManager
# フラグを渡しており、その値に応じてnix/home.nixのdrsw/hmswエイリアスのうち
# 今のモードで使わない方はそもそも定義されず、コマンド自体が存在しなくなる。

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
      mkPkgs = sys: import nixpkgs {
        system = sys;
        config.allowUnfreePredicate = unfreePredicate;
      };
      pkgs = mkPkgs system;
      # home-manager単体: home.nix(dotfiles) + nixvim.nixをdarwinを介さず単体で反映
      mkHomeConfiguration = sys: home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs sys;
        # home-manager単体モード: home.nix側でdrswを無効化させる
        extraSpecialArgs = { inherit username; darwinManagesHomeManager = false; };
        modules = [
          nixvim.homeModules.nixvim
          ./nix/home.nix
          ./nix/nixvim.nix
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
            # darwin統合モード: home.nix側でhmswを無効化させる
            home-manager.extraSpecialArgs = { inherit username; darwinManagesHomeManager = true; };
          }
        ];
        specialArgs = { inherit username; };
      };

      # home-manager単体 (macOS): darwinを介さずhome.nix/nixvim.nixだけを反映
      homeConfigurations."ne0san" = mkHomeConfiguration system;

      # home-manager単体 (Linux): darwin/homebrew前提の設定を切り離した状態で反映
      homeConfigurations."ne0san-linux-x86_64" = mkHomeConfiguration "x86_64-linux";
      homeConfigurations."ne0san-linux-aarch64" = mkHomeConfiguration "aarch64-linux";
    };
}
