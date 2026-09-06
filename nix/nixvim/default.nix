{ ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    imports = [
      ./options.nix
      ./autocmds.nix
      ./highlights.nix
      ./user-commands.nix
      ./extra-plugins.nix
      ./lua
      ./keymaps
      ./plugins
    ];
  };
}
