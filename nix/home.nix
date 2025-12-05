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
    neovim
    tree
    lua
    elixir
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
}
