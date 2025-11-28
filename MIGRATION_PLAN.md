# dotfiles → home-manager & nix-darwin 移行計画

## 📋 現状把握

現在のdotfilesの構成：

1. **Homebrew関連** (`.bin/.Brewfile`)
   - フォント（0xProto Nerd Font, Daddy Time Mono Nerd Font, Hack Nerd Font, Myrica）
   - アプリ（Ghostty、Raycast、Arc）

2. **Zsh設定** (`.bin/.zshrc.shared`)
   - oh-my-zsh（テーマ: rkj-repos）
   - プラグイン（git, zsh-autosuggestions）
   - エイリアス（vi→nvim, view→nvim -R, ll→ls -l）
   - 環境変数、履歴設定
   - direnvの統合

3. **macOS defaults設定** (`defaults/defaults.sh`)
   - スクリーンショット保存先
   - トラックパッド感度
   - Dock（自動非表示、最近使用したアプリ非表示、最小化をアプリアイコンへ）
   - Finder（拡張子表示、隠しファイル表示、ホームディレクトリ表示、カラム表示）
   - キーボード（Caps Lock→Control、リピート速度、Fnキー設定）
   - ダークモード
   - 起動音無効化

4. **Ghostty設定** (`ghostty/.config/ghostty/config`)
   - フォント設定

5. **Neovim設定** (`astronvim/astronvim.sh`)
   - AstroNvimのセットアップ

---

## 🎯 移行計画（フェーズ別）

### Phase 1: 基礎セットアップ

#### 1. flake.nixの作成

プロジェクトのルートに`flake.nix`を作成し、home-managerとnix-darwinをinputsに追加。

```nix
{
  description = "macOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager }: {
    # darwinConfigurationsを定義
    # home-managerの統合
  };
}
```

#### 2. ディレクトリ構造の設計

```
dotfiles/
├── flake.nix
├── flake.lock
├── modules/
│   ├── darwin/              # nix-darwin設定
│   │   ├── default.nix
│   │   ├── homebrew.nix
│   │   ├── defaults.nix
│   │   └── system.nix
│   └── home/                # home-manager設定
│       ├── default.nix
│       ├── shell.nix        # zsh設定
│       ├── programs/        # アプリ別設定
│       │   ├── neovim.nix
│       │   ├── ghostty.nix
│       │   └── git.nix
│       └── packages.nix
└── legacy/                  # 旧スクリプト（移行後）
```

---

### Phase 2: nix-darwin設定への移行

#### 3. Homebrew管理の移行

**移行元**: `.bin/.Brewfile`
**移行先**: `modules/darwin/homebrew.nix`

```nix
{ ... }:

{
  homebrew = {
    enable = true;

    taps = [
      "aws/tap"
      "modularml/packages"
      "oven-sh/bun"
    ];

    casks = [
      "font-0xproto-nerd-font"
      "font-daddy-time-mono-nerd-font"
      "font-hack-nerd-font"
      "font-myrica"
      "ghostty"
      "raycast"
      "arc"
    ];

    # 自動更新・クリーンアップ設定
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
  };
}
```

#### 4. macOS defaults設定の移行

**移行元**: `defaults/defaults.sh`
**移行先**: `modules/darwin/defaults.nix`

```nix
{ ... }:

{
  system.defaults = {
    # Dock設定
    dock = {
      autohide = true;
      show-recents = false;
      minimize-to-application = true;
    };

    # Finder設定
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      NewWindowTarget = "PfHm";
      NewWindowTargetPath = "file://${HOME}/";
      FXPreferredViewStyle = "clmv";  # カラム表示
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

    # スクリーンショット設定
    screencapture = {
      location = "~/Pictures";
    };

    # トラックパッド設定
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };
  };

  # Caps Lock → Control
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
}
```

**注意**: 以下の設定はnix-darwinで直接サポートされていないため、別途スクリプト化が必要：
- 起動音無効化（`sudo nvram StartupMute=%01`）
- Fnキーの特別機能無効化（`com.apple.HIToolbox AppleFnUsageType`）

#### 5. システム全体の設定

**移行先**: `modules/darwin/system.nix`

```nix
{ ... }:

{
  # Nixの設定
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  # システムバージョン
  system.stateVersion = 4;

  # 自動最適化
  nix.optimise.automatic = true;
}
```

---

### Phase 3: home-manager設定への移行

#### 6. Zsh設定の移行

**移行元**: `.bin/.zshrc.shared`
**移行先**: `modules/home/shell.nix`

```nix
{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    # oh-my-zsh設定
    oh-my-zsh = {
      enable = true;
      theme = "rkj-repos";
      plugins = [
        "git"
        "zsh-autosuggestions"
      ];
    };

    # エイリアス
    shellAliases = {
      vi = "nvim";
      view = "nvim -R";
      ll = "ls -l";
    };

    # 環境変数
    sessionVariables = {
      RUBY_TCP_NO_FAST_FALLBACK = "1";
    };

    # 履歴設定
    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      share = true;
    };

    # 追加設定
    initExtra = ''
      setopt auto_cd
      setopt correct
      setopt correct_all

      # 必要に応じてPATHを追加
      export PATH=/Users/asamitomo/.tiup/bin:$PATH
    '';
  };

  # direnv統合
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
```

#### 7. Ghostty設定の移行

**移行元**: `ghostty/.config/ghostty/config`
**移行先**: `modules/home/programs/ghostty.nix`

```nix
{ ... }:

{
  xdg.configFile."ghostty/config".text = ''
    font-family = "0xProto Nerd Font"
    font-family = "MyricaM M"
    font-size = 11
  '';
}
```

#### 8. Neovim設定の移行

**移行元**: `astronvim/astronvim.sh`
**移行先**: `modules/home/programs/neovim.nix`

```nix
{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  # AstroNvim設定のクローン
  home.activation.cloneAstroNvim = ''
    if [ ! -d "$HOME/.config/nvim" ]; then
      # バックアップ作成
      [ -d "$HOME/.config/nvim" ] && mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
      [ -d "$HOME/.local/share/nvim" ] && mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.bak"
      [ -d "$HOME/.local/state/nvim" ] && mv "$HOME/.local/state/nvim" "$HOME/.local/state/nvim.bak"
      [ -d "$HOME/.cache/nvim" ] && mv "$HOME/.cache/nvim" "$HOME/.cache/nvim.bak"

      # AstroNvimクローン
      ${pkgs.git}/bin/git clone https://github.com/ne0san/ne0nvim.git "$HOME/.config/nvim"
    fi
  '';
}
```

#### 9. Git設定の追加

**移行先**: `modules/home/programs/git.nix`

```nix
{ ... }:

{
  programs.git = {
    enable = true;

    userName = "あなたの名前";
    userEmail = "your-email@example.com";

    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
    };

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
```

#### 10. パッケージ管理

**移行先**: `modules/home/packages.nix`

```nix
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # 開発ツール
    # Homebrewから移行できるものをここに追加
  ];
}
```

---

### Phase 4: 既存スクリプトの置き換え・統合

#### 11. インストールスクリプトの統合

- 各種`.sh`ファイルを`legacy/`ディレクトリに移動
- `brew.sh`, `zsh.sh`, `defaults.sh`, `ghostty.sh`, `astronvim.sh`は不要に

#### 12. bootstrap/セットアップスクリプトの作成

新規セットアップ用のスクリプトを作成：

```bash
#!/bin/bash
# bootstrap.sh

# Nixインストール（未インストールの場合）
if ! command -v nix &> /dev/null; then
    sh <(curl -L https://nixos.org/nix/install)
fi

# nix-darwinのインストールと適用
nix run nix-darwin -- switch --flake .

# home-managerの適用
nix run home-manager -- switch --flake .
```

---

### Phase 5: テスト・検証

#### 13. 段階的なテスト

各モジュールごとにテスト：

```bash
# nix-darwinの適用
darwin-rebuild switch --flake .

# home-managerの適用
home-manager switch --flake .
```

設定が正しく反映されるか確認：
- Dock設定
- Finder設定
- キーボード設定
- Zshのエイリアスと環境変数
- アプリケーションの起動

#### 14. ロールバック手順の確認

```bash
# nix-darwinのロールバック
darwin-rebuild --rollback

# home-managerの世代確認と切り替え
home-manager generations
home-manager switch --switch-generation <generation-number>
```

---

## ⚠️ 注意点・制約事項

### 1. nix-darwinで完全に置き換えできない設定

以下の設定は別途シェルスクリプトとして残す必要がある：

- **起動音無効化**: `sudo nvram StartupMute=%01`
- **Fnキーの特別機能無効化**: `defaults write com.apple.HIToolbox AppleFnUsageType -int 0`
- **一部のキーボードマッピング**: デバイス依存の設定

これらは`legacy/manual-setup.sh`として残すか、`home.activation`スクリプト内で実行。

### 2. oh-my-zshの扱い

- home-managerで管理可能
- カスタムプラグインの扱いに注意
- zsh-autosuggestionsはnixpkgsから入れることも可能：
  ```nix
  programs.zsh.plugins = [
    {
      name = "zsh-autosuggestions";
      src = pkgs.zsh-autosuggestions;
    }
  ];
  ```

### 3. フォントの扱い

- Nerd Fontsはhome-managerの`fonts.fontconfig`でも管理できる
- ただしHomebrewのcask経由のほうがシンプル
- 推奨: Homebrewで管理を継続

### 4. 状態の管理

- dotfilesは宣言的になるが、初回適用時に既存の設定との競合に注意
- **必ずバックアップを取ってから移行**
- 既存の設定ファイルは自動でバックアップされる（`.bak`サフィックス）

### 5. GitHub Actionsとの統合

- 既存の`nix/nix.sh`の`NIX_SKIP_INSTALL`チェックを維持
- CIでは`nix build`や`nix flake check`でビルドテスト

---

## 🎁 移行のメリット

- ✅ **宣言的管理**: 全設定がコードとして一箇所に集約
- ✅ **再現性**: どのマシンでも同じ環境を構築可能
- ✅ **世代管理**: いつでも以前の設定にロールバック可能
- ✅ **依存関係の明確化**: `flake.lock`でバージョン固定
- ✅ **差分管理**: Gitで設定の変更履歴を追跡
- ✅ **原子性**: 設定適用は成功か失敗かのどちらか（部分的な適用はない）
- ✅ **テスト可能**: 本番適用前にビルドテストが可能

---

## 📝 移行の進め方（推奨順序）

1. **Phase 1**: flake.nixと基礎構造を作成
2. **Phase 2**: nix-darwin設定から開始（システムレベル）
   - Homebrew管理
   - macOS defaults
3. **Phase 3**: home-manager設定（ユーザーレベル）
   - Zsh設定
   - アプリケーション設定
4. **Phase 4**: 既存スクリプトの整理
5. **Phase 5**: テストとドキュメント更新

段階的に移行し、各フェーズで動作確認することを推奨。

---

## 📚 参考リンク

- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [home-manager](https://github.com/nix-community/home-manager)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [macOS Configuration Examples](https://github.com/LnL7/nix-darwin#example)
