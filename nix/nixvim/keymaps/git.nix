{ pkgs, ... }:

let
  # jjui内でファイルをeditする際、nvimの:terminalから開いている場合は
  # $NVIMに親nvimのソケットパスが設定されているため、それを使って
  # 新規にnvimを入れ子起動するのではなく既存のnvimにタブとして開かせる
  # (lazygitのos.editPreset = "nvim-remote"と同じ考え方)
  jjuiNvimRemoteEdit = pkgs.writeShellScript "jjui-nvim-remote-edit" ''
    if [ -n "$NVIM" ]; then
      nvim --server "$NVIM" --remote-tab "$1"

      # Neovimは(Vimと違い)--remote-wait系のオプションを未実装のため、
      # 上のremote-tabはタブを開いた瞬間に処理が返ってしまう。
      # jjui/lazygitはこのスクリプト(EDITOR)のプロセスが終了したタイミングで
      # description等のファイルを読み込むため、ここで実際にブロックしないと
      # 編集前(未保存)の内容がそのまま読み込まれてしまう。
      # そこで--remote-exprで開いたバッファがまだ残っているかをポーリングし、
      # 親nvim側でタブ/バッファを閉じる(:wq等で保存して抜ける)までここで待機する。
      escaped=$(printf '%s' "$1" | sed "s/'/'''/g")
      while [ "$(nvim --server "$NVIM" --remote-expr "bufloaded('$escaped')" 2>/dev/null)" = "1" ]; do
        sleep 0.2
      done
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
