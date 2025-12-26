{ config, pkgs, username, ... }:
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
  ];
  home.file = {
  };
  home.sessionVariables = {
  };
  programs.home-manager.enable = true;
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

    # zprofileに書く内容（ログインシェル時に実行）
    profileExtra = ''
      # Homebrewのパスを追加
      if [ -d "/opt/homebrew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [ -d "/usr/local/Homebrew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
      fi
    '';

    # その他のinitExtra（宣言的にできない部分だけ）
    initContent = ''
      setopt correct
      setopt correct_all
      export PATH=/Users/${username}/.tiup/bin:$PATH
      export RUBY_TCP_NO_FAST_FALLBACK=1
      . "/etc/profiles/per-user/${username}/etc/profile.d/hm-session-vars.sh"
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
        name = "neosan";
        email = "ne0l1gh7@vivaldi.net";
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
