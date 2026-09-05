{ pkgs, username, ... }:
let
  # ローカルのgit識別情報を読み込む（make git-identity で生成）
  # ~/.config/git-identity-{name,email} からユーザー情報を取得
  configDir = "/Users/${username}/.config";
  gitUserName =
    let f = "${configDir}/git-identity-name";
    in if builtins.pathExists f
      then builtins.replaceStrings ["\n"] [""] (builtins.readFile f)
      else "unknown";
  gitUserEmail =
    let f = "${configDir}/git-identity-email";
    in if builtins.pathExists f
      then builtins.replaceStrings ["\n"] [""] (builtins.readFile f)
      else "unknown@example.com";
  tle = pkgs.buildGoModule {
    pname = "tle";
    version = "1.2.0";
    src = pkgs.fetchFromGitHub {
      owner = "drand";
      repo = "tlock";
      rev = "v1.2.0";
      sha256 = "sha256-3qO5xGcKj7m033B/lWoeewUf9XbiY+GrQFBBuymOXzo=";
    };
    vendorHash = "sha256-gy2aPcOrhN1M27qYiqRvNjy987Oh7/MHMvbRLEpV3Iw=";
    subPackages = [ "cmd/tle" ];
  };
in
{
  home.enableNixpkgsReleaseCheck = false;
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    devenv
    ripgrep
    cmake
    git-secrets
    gnupg
    tree
    lua
    nil  # Nix LSP
    lua-language-server
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    gopls
    _1password-cli
    gh
    claude-code
    tle
    fd
    dotnet-sdk_10
  ];
  programs.home-manager.enable = true;
  programs.starship = {
    enable = true;
    settings = {

      format = "$all$env_var$time$status$character";

      time = {
        disabled = false;
        format = "🕐 [$time]($style) ";
        time_format = "%T";
      };

      status = {
        disabled = false;
        format = "[$symbol$status]($style) ";
      };
      add_newline = true;

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      directory = {
        truncation_length = 99;
        truncate_to_repo = true;
      };

      # ブランチ表示はcustom.vcs_branchに一本化するため無効化
      # （jjとgitが共存するリポジトリでは、両方の表示が重複してしまうため）
      git_branch = {
        disabled = true;
      };

      custom = {
        # jjリポジトリ（gitとの共存含む）では「一番近いbookmark名+そこからのchange数」
        # （例: bookmarkの真上なら"main"、1つ先なら"main+1"、bookmarkが複数ヒットする場合は"(main,main)+1"）を、
        # 純粋なgitリポジトリではgitのブランチ名を表示する
        # jjとgitが共存する場合はjjの情報を優先する
        # closest_bookmark(to) は programs.jujutsu.settings.revset-aliases で定義済み
        vcs_branch = {
          # shellを明示しないとSTARSHIP_SHELL（fish）経由で実行されてしまい、
          # 下記の sh/POSIX 構文（if...then...fi 等）がパースエラーになるため固定する
          shell = [ "sh" ];
          when = "jj root --ignore-working-copy >/dev/null 2>&1 || git rev-parse --is-inside-work-tree >/dev/null 2>&1";
          command = ''
            if jj root --ignore-working-copy >/dev/null 2>&1; then
              conflict=$(jj log --no-graph -r @ -T 'if(conflict, "💥 ")' 2>/dev/null)
              bm=$(jj log --no-graph -r 'closest_bookmark(@)' -T 'bookmarks.map(|b| b.name()).join(",")' 2>/dev/null)
              if [ -n "$bm" ]; then
                # 同名でlocal/remote両方のbookmarkがある等、複数ヒットする場合は()で囲む
                case "$bm" in
                  *,*) bm="($bm)" ;;
                esac
                dist=$(jj log --no-graph -r 'closest_bookmark(@)..@' -T '"."' 2>/dev/null | wc -c | tr -d ' ')
                dist=''${dist:-0}
                if [ "$dist" -gt 0 ]; then
                  # +N部分だけ薄い色にするため、ANSIエスケープを直接出力に埋め込む
                  # （unsafe_no_escape=trueでこの出力をそのまま解釈させる）
                  printf '%s%s\033[0m\033[2m+%s\033[0m' "$conflict" "$bm" "$dist"
                else
                  printf '%s%s' "$conflict" "$bm"
                fi
              else
                change_id=$(jj log --no-graph -r @ -T 'change_id.shortest(8)' 2>/dev/null)
                printf '%s%s' "$conflict" "$change_id"
              fi
            else
              git branch --show-current 2>/dev/null
            fi
          '';
          symbol = "🔧 ";
          format = "[$symbol$output]($style) ";
          style = "bold green";
          unsafe_no_escape = true;
        };
      };

      env_var = {
        STARSHIP_SHELL = {
          variable = "STARSHIP_SHELL";
          format = "[$env_value]($style) ";
          style = "bold cyan";
        };
      };
    };
  };
  programs.ghostty = {
    enable = true;
    package = null;  # macOS用
    enableFishIntegration = true;

    settings = {
      command = "${pkgs.fish}/bin/fish";
      font-family = [
        "0xProto Nerd Font"
        "MyricaM M"
      ];
      font-size = 11.5;
      macos-option-as-alt = true;
    };
  };
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
    ];
    shellInit = ''
      # Nix daemonのパスを読み込み
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end
      # Home Managerのプロファイルパスを明示的に追加
      fish_add_path --prepend --move --path $HOME/.nix-profile/bin
      fish_add_path --prepend --move --path /etc/profiles/per-user/$USER/bin
      fish_add_path --prepend --move --path /run/current-system/sw/bin
      # Homebrew (Apple Silicon) のパスを追加
      # toggletermなどのサブシェルでもbrewコマンドが使えるようにする
      if test -d /opt/homebrew
        fish_add_path --append /opt/homebrew/bin /opt/homebrew/sbin
      end
    '';
    # インタラクティブシェル用の設定
    interactiveShellInit = ''
      set fish_greeting
    '';

    # 略語設定
    shellAbbrs = {
      vi = "nvim";
      view = "nvim -R";
      ll = "ls -alF";
      flupd = "nix flake update --flake ~/dotfiles";
      drsw = "sudo USER=$USER darwin-rebuild switch --flake ~/dotfiles#ne0san --impure";
      hmsw = "home-manager switch --flake ~/dotfiles#ne0san --impure";
      nvsw = "home-manager switch --flake ~/dotfiles#nixvim --impure";
      freload = "source ~/.config/fish/config.fish";
      fsi = "dotnet fsi";
      dev = "~/Documents/Develop/";
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;

    # oh-my-zshの宣言的設定
    oh-my-zsh = {
      enable = true;
      theme = "rkj-repos";
      plugins = [
        "git"
      ];
    };

    # ヒストリ設定
    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      share = true;
      extended = true;  # HIST_STAMPSの代わり（タイムスタンプ記録）
    };

    # エイリアス
    shellAliases = {
      vi = "nvim";
      view = "nvim -R";
      ll = "ls -alF";
      flupd = "nix flake update --flake ~/dotfiles";
      drsw = "sudo USER=$USER darwin-rebuild switch --flake ~/dotfiles#ne0san --impure";
      hmsw = "home-manager switch --flake ~/dotfiles#ne0san --impure";
      nvsw = "home-manager switch --flake ~/dotfiles#nixvim --impure";
      zreload = "source ~/.zshrc";
      dev = "cd ~/Documents/Develop/";
    };

    # setopt系
    autocd = true;

    # その他のinitExtra（宣言的にできない部分だけ）
    initContent = ''
      setopt correct
      setopt correct_all
    '';
  };

  programs.git = {
    enable = true;

    ignores = [
      "*~"
      ".DS_Store"
    ];

    settings = {
      user = {
        name = gitUserName;
        email = gitUserEmail;
      };
      init = {
        defaultBranch = "main";
        templatedir = "/Users/${username}/.git-templates/git-secrets/";
      };
      commit = {
        template = "/Users/${username}/.stCommitMsg";
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        language = "ja";
      };
      os = {
        editPreset = "nvim-remote";
      };
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = gitUserName;
        email = gitUserEmail;
      };
      ui = {
        default-command = "log";
      };
      revset-aliases = { # changeもしくはその集合を示すクエリのエイリアスを作成
        "closest_bookmark(to)" = "heads(::to & bookmarks())";  # toから遡る全てのchangeのうち、bookmarkがついているものだけ、の先頭
      };
      aliases = {
        tug = [ # 一番近い過去のbookmarkを一個前のchangeに移動する
          "bookmark"
          "move"
          "--from"
          "closest_bookmark(@-)"
          "--to"
          "@-"
        ];
      };
    };
  };

  programs.jjui = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
