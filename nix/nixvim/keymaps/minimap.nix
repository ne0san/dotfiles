{ ... }:

{
  # キーマップ (codewindow と同様の <leader>m プレフィックス)
  keymaps = [
    {
      mode = "n";
      key = "<leader>mm";
      action = "<cmd>Neominimap Toggle<cr>";
      options.desc = "Toggle minimap";
    }
    {
      mode = "n";
      key = "<leader>mo";
      action = "<cmd>Neominimap Enable<cr>";
      options.desc = "Open minimap";
    }
    {
      mode = "n";
      key = "<leader>mc";
      action = "<cmd>Neominimap Disable<cr>";
      options.desc = "Close minimap";
    }
    {
      mode = "n";
      key = "<leader>mf";
      action = "<cmd>Neominimap Focus<cr>";
      options.desc = "Focus minimap";
    }
  ];
}
