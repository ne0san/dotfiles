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
      "com.apple.swipescrolldirection" = true;
    };
    # nix-darwinに定義されてないやつはここに書く
    CustomUserPreferences = {
      NSGlobalDomain = {
        "com.apple.mouse.scaling" = 1.0;
        "com.apple.scrollwheel.scaling" = 0.4412;
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
  # Google日本語入力の入力ソースを設定
  system.activationScripts.postActivation.text = ''
    echo "Setting up Google Japanese IME input sources..."
    sudo -u ${username} /usr/bin/defaults write com.apple.HIToolbox AppleEnabledInputSources -array \
      '{ "Bundle ID" = "com.google.inputmethod.Japanese"; InputSourceKind = "Keyboard Input Method"; }' \
      '{ "Bundle ID" = "com.google.inputmethod.Japanese"; "Input Mode" = "com.google.inputmethod.Japanese.base"; InputSourceKind = "Input Mode"; }' \
      '{ "Bundle ID" = "com.google.inputmethod.Japanese"; "Input Mode" = "com.google.inputmethod.Japanese.Roman"; InputSourceKind = "Input Mode"; }'

    # 設定を即座に反映
    sudo -u ${username} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
  # システムバージョン
  system.stateVersion = 5;
}
