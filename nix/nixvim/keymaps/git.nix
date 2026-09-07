{ pkgs, ... }:

let
  # jjui内でファイルをeditする際、nvimの:terminalから開いている場合は
  # $NVIMに親nvimのソケットパスが設定されているため、それを使って
  # 新規にnvimを入れ子起動するのではなく既存のnvimにタブとして開かせる
  # (lazygitのos.editPreset = "nvim-remote"と同じ考え方)
  jjuiNvimRemoteEdit = pkgs.writeShellScript "jjui-nvim-remote-edit" ''
    if [ -n "$NVIM" ]; then
      exec nvim --server "$NVIM" --remote-tab "$1"
    else
      exec nvim "$1"
    fi
  '';
in
{
  keymaps = [
    {
      mode = "n";
      key = "<leader>gg";
      action.__raw = "function() Snacks.lazygit() end";
      options.desc = "Lazygit";
    }
    {
      mode = "n";
      key = "<leader>jj";
      action.__raw = ''function() Snacks.terminal.toggle("jjui", { win = { style = "float", backdrop = false, wo = { winblend = 15 } }, count = 5, env = { EDITOR = "${jjuiNvimRemoteEdit}", VISUAL = "${jjuiNvimRemoteEdit}" } }) end'';
      options.desc = "Jjui";
    }
    {
      mode = "n";
      key = "<leader>gc";
      action.__raw = "function() Snacks.gitbrowse() end";
      options.desc = "Open file/commit in browser";
    }
    {
      mode = "n";
      key = "<leader>gp";
      action = "<cmd>GitBlameCopyPRURL<cr>";
      options.desc = "Copy PR URL";
    }
  ];
}
