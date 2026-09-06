{ ... }:

{
  keymaps = [
    # ===== AutoSession ======
    # セッション検索・選択（Telescope使用）
    {
      mode = "n";
      key = "<leader>ss";
      action = "<cmd>AutoSession search<CR>";
      options = {
        desc = "Search sessions";
        silent = true;
      };
    }

    # セッション保存
    {
      mode = "n";
      key = "<leader>sw";
      action = "<cmd>AutoSession save<CR>";
      options = {
        desc = "Save session";
        silent = true;
      };
    }

    # セッション削除
    {
      mode = "n";
      key = "<leader>sd";
      action = "<cmd>AutoSession delete<CR>";
      options = {
        desc = "Delete session";
        silent = true;
      };
    }

    # 最後のセッションを復元
    {
      mode = "n";
      key = "<leader>sl";
      action = "<cmd>AutoSession restore_last<CR>";
      options = {
        desc = "Restore last session";
        silent = true;
      };
    }

    # 自動保存トグル
    {
      mode = "n";
      key = "<leader>st";
      action = "<cmd>AutoSession toggle<CR>";
      options = {
        desc = "Toggle autosave";
        silent = true;
      };
    }
  ];
}
