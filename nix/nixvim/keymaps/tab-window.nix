{ ... }:

{
  keymaps = [
    # ===== タブ操作 (AstroNvim風) =====
    {
      mode = "n";
      key = "<leader><Tab>n";
      action = "<cmd>tabnew<CR>";
      options.desc = "New tab";
    }
    {
      mode = "n";
      key = "<leader><Tab>c";
      action = "<cmd>tabclose<CR>";
      options.desc = "Close tab";
    }
    {
      mode = "n";
      key = "<leader><Tab>o";
      action = "<cmd>tabonly<CR>";
      options.desc = "Close other tabs";
    }
    {
      mode = "n";
      key = "<leader><Tab>m";
      action = "<C-w>T";
      options.desc = "Move window to new tab";
    }
    # 標準の gt/gT でも切り替え可能だが、<leader><Tab> グループ側からも
    # 一貫して操作できるようにエイリアスを用意する
    {
      mode = "n";
      key = "<leader><Tab>]";
      action = "<cmd>tabnext<CR>";
      options.desc = "Next tab";
    }
    {
      mode = "n";
      key = "<leader><Tab>[";
      action = "<cmd>tabprevious<CR>";
      options.desc = "Previous tab";
    }
    # ===== ウィンドウ分割 (AstroNvim風) =====
    {
      mode = "n";
      key = "|";
      action = "<cmd>vsplit<CR>";
      options.desc = "Vertical split";
    }
    {
      mode = "n";
      key = "\\";
      action = "<cmd>split<CR>";
      options.desc = "Horizontal split";
    }

    # ===== ウィンドウ操作 (smart-splits) =====
    {
      mode = "n";
      key = "<C-h>";
      action.__raw = "function() require('smart-splits').move_cursor_left() end";
      options.desc = "Move to left window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action.__raw = "function() require('smart-splits').move_cursor_down() end";
      options.desc = "Move to bottom window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action.__raw = "function() require('smart-splits').move_cursor_up() end";
      options.desc = "Move to top window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action.__raw = "function() require('smart-splits').move_cursor_right() end";
      options.desc = "Move to right window";
    }
    {
      mode = "n";
      key = "<M-k>";
      action.__raw = "function() require('smart-splits').resize_up() end";
      options.desc = "Resize window up";
    }
    {
      mode = "n";
      key = "<M-j>";
      action.__raw = "function() require('smart-splits').resize_down() end";
      options.desc = "Resize window down";
    }
    {
      mode = "n";
      key = "<M-h>";
      action.__raw = "function() require('smart-splits').resize_left() end";
      options.desc = "Resize window left";
    }
    {
      mode = "n";
      key = "<M-l>";
      action.__raw = "function() require('smart-splits').resize_right() end";
      options.desc = "Resize window right";
    }
    # ウィンドウ移動 (Shift + 矢印キー)
    {
      mode = "n";
      key = "<S-Left>";
      action.__raw = "function() require('smart-splits').move_cursor_left() end";
      options.desc = "Move to left window";
    }
    {
      mode = "n";
      key = "<S-Down>";
      action.__raw = "function() require('smart-splits').move_cursor_down() end";
      options.desc = "Move to bottom window";
    }
    {
      mode = "n";
      key = "<S-Up>";
      action.__raw = "function() require('smart-splits').move_cursor_up() end";
      options.desc = "Move to top window";
    }
    {
      mode = "n";
      key = "<S-Right>";
      action.__raw = "function() require('smart-splits').move_cursor_right() end";
      options.desc = "Move to right window";
    }

    # ウィンドウサイズ変更 (Alt + Shift + 矢印キー)
    {
      mode = "n";
      key = "<M-S-Up>";
      action.__raw = "function() require('smart-splits').resize_up() end";
      options.desc = "Resize window up";
    }
    {
      mode = "n";
      key = "<M-S-Down>";
      action.__raw = "function() require('smart-splits').resize_down() end";
      options.desc = "Resize window down";
    }
    {
      mode = "n";
      key = "<M-S-Left>";
      action.__raw = "function() require('smart-splits').resize_left() end";
      options.desc = "Resize window left";
    }
    {
      mode = "n";
      key = "<M-S-Right>";
      action.__raw = "function() require('smart-splits').resize_right() end";
      options.desc = "Resize window right";
    }
  ];
}
