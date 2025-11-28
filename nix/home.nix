{ config, pkgs, ... }:

{
  home.enableNixpkgsReleaseCheck = false;
  home.username = "asamitomo";
  home.homeDirectory = "/Users/asamitomo";
  home.stateVersion = "25.05"; # Please read the comment before changing.
  home.packages = with pkgs; [
    devenv
    direnv
    nix-direnv
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
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    initExtra = ''
      ### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
      export PATH="/Users/asamitomo/.rd/bin:$PATH"
      ### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
      export ZSH="$HOME/.oh-my-zsh"
      ZSH_THEME="rkj-repos"
      zstyle ":omz:update" mode auto
      COMPLETION_WAITING_DOTS="true"
      HIST_STAMPS="yyyy-mm-dd"
      plugins=(
          git
          zsh-autosuggestions
      )

      source $ZSH/oh-my-zsh.sh

      # MyAliases
      alias vi="nvim"
      alias view="nvim -R"
      alias ll="ls -l"

      setopt auto_cd
      setopt correct
      setopt correct_all
      setopt hist_ignore_dups
      setopt share_history
      setopt inc_append_history
      export HISTFILE=~/.zsh_history
      export HISTSIZE=10000
      export SAVEHIST=10000

      export PATH=/Users/asamitomo/.tiup/bin:$PATH
      export RUBY_TCP_NO_FAST_FALLBACK=1
      eval "$(direnv hook zsh)"
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
  };
}
