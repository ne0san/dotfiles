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
    elixir
    nil  # Nix LSP
    lua-language-server
    winetricks
    nushell
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    gopls
    nodejs
    yazi
    zellij
    _1password-cli
    gh
    claude-code
  ];
  home.file = {
  };
  home.sessionVariables = {
  };
  programs.home-manager.enable = true;
  programs.starship = {
    enable = true;
    settings = {

      format = "$all$time$status$character";

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

      git_branch = {
        symbol = "🔧 ";
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
      font-size = 10;
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
      ll = "ls -l";
      flupd = "nix flake update --flake ~/dotfiles/nix";
      drsw = "sudo USER=$USER darwin-rebuild switch --flake ~/dotfiles/nix#ne0san --impure";
      freload = "source ~/.config/fish/config.fish";
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
      ll = "ls -l";
      flupd = "nix flake update --flake ~/dotfiles/nix";
      drsw = "sudo USER=$USER darwin-rebuild switch --flake ~/dotfiles/nix#ne0san --impure";
      zreload = "source ~/.zshrc";
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
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        language = "ja";
      };
    };
  };
  programs.helix = {
    enable = true;
    settings = {
      theme = "onedark";
      editor = {
        lsp.display-messages = true;
        cursor-shape = {
          insert = "bar";
          select = "underline";
        };
        file-picker = {
          hidden = false;
        };
        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "warning";
        };
      };
    };
    languages = {
      language-server.gopls = {
        command = "${pkgs.gopls}/bin/gopls";
        args = [ "-logfile=/tmp/gopls.log" "serve" ];
        config = {
          "ui.diagnostic.staticcheck" = true;
        };
      };

      language-server.typescript-language-server = {
        command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
        args = [ "--stdio" ];
        config = {
          plugins = [
            {
              name = "@vue/typescript-plugin";
              location = "${pkgs.nodePackages."@vue/language-server"}/lib/node_modules/@vue/language-server";
              languages = [ "vue" ];
            }
          ];
        };
      };

      language = [
        {
          name = "vue";
          language-servers = [ "typescript-language-server" "vuels" ];
        }
      ];
    };
  };
}
