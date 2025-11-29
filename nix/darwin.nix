
{ config, pkgs, username, ... }:

{
  # Nix設定
  nix.settings.experimental-features = "nix-command flakes";
  
  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };
  # システムパッケージ
  environment.systemPackages = with pkgs; [
    vim
  ];
  homebrew = {
    enable = true;
    
    # darwin-rebuild時に、nixで管理してないbrewパッケージを消すかどうか
    # "none" = 消さない（一時的なやつ残る）
    # "uninstall" = 消す
    onActivation.cleanup = "none";
    
    taps = [
      "aws/tap"
      "modularml/packages"
      "oven-sh/bun"
    ];
    
    brews = [
      "node"
    ];
  
    casks = [
      "font-0xproto-nerd-font"
      "font-daddy-time-mono-nerd-font"
      "font-hack-nerd-font"
      "font-myrica"
      "ghostty"
      "raycast"
      "arc"
      "google-japanese-ime"
    ];
  };
  # macOS システムデフォルト設定
  system.defaults = {
    # Dock
    dock = {
      autohide = true;
      show-recents = false;
      minimize-to-application = true;
    };

    # Finder
    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
      NewWindowTarget = "Home";
    };

    # スクリーンキャプチャ
    screencapture.location = "~/Pictures";

    # トラックパッド
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };

    # グローバル設定
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark";
      InitialKeyRepeat = 30;
      KeyRepeat = 2;
      "com.apple.keyboard.fnState" = true;
      "com.apple.trackpad.scaling" = 1.5;
    };
  };

  # システムバージョン
  system.stateVersion = 5;
}
