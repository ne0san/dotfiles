{ config, pkgs, username, ... }:

{
  # Nix設定
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.trusted-users = [ "root" "@admin" ];

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
      "gcenx/wine/wine-crossover"
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
      "com.apple.swipescrolldirection" = true;
    };
    # nix-darwinに定義されてないやつはここに書く
    CustomUserPreferences = {
      NSGlobalDomain = {
        "com.apple.mouse.scaling" = 1.0;
        "com.apple.scrollwheel.scaling" = 0.4412;
      };
      "com.apple.PowerChime" = {
        ChimeOnAllHardware = false;
      };
    };
  };

  # キーボード設定
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;  # CapsLockをControlに変更
  };

  # 起動音をオフ
  system.startup.chime = false;
  # システムバージョン
  system.stateVersion = 5;
}
