
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
