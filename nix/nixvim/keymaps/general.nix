{ ... }:

{
  keymaps = [
    # ===== 一般 =====
    # ESCでハイライト消去
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Clear search highlight";
    }
    # ttでノーマルモードに戻る
    {
      mode = "i";
      key = "tt";
      action = "<Esc>";
      options.desc = "Exit insert mode";
    }
    # qqでノーマルモードに戻る
    {
      mode = "i";
      key = "qq";
      action = "<Esc>";
      options.desc = "Exit insert mode";
    }
    # ターミナルモードでqqでノーマルモードに戻る
    {
      mode = "t";
      key = "qq";
      action = "<C-\\><C-n>";
      options.desc = "Exit terminal mode";
    }
    # Opt+Deleteで単語削除（テキストボックスと同じ挙動）
    {
      mode = "i";
      key = "<M-BS>";
      action = "<C-w>";
      options.desc = "Delete word before cursor";
    }
    {
      mode = "i";
      key = "<M-Del>";
      action = "<C-o>dw";
      options.desc = "Delete word after cursor";
    }

    # ===== yw/yW/dw/dW: 単語先頭から操作 =====
    {
      mode = "n";
      key = "yw";
      action.__raw = "smart_word_op('y', false)";
      options.desc = "Yank from word start";
    }
    {
      mode = "n";
      key = "yW";
      action.__raw = "smart_word_op('y', true)";
      options.desc = "Yank from WORD start";
    }
    {
      mode = "n";
      key = "dw";
      action.__raw = "smart_word_op('d', false)";
      options.desc = "Delete from word start";
    }
    {
      mode = "n";
      key = "dW";
      action.__raw = "smart_word_op('d', true)";
      options.desc = "Delete from WORD start";
    }

    # ===== Save/Quit =====
    {
      mode = "n";
      key = "<leader>w";
      action = "<cmd>w<CR>";
      options.desc = "Save";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>q<CR>";
      options.desc = "Quit";
    }
    # 行末画面内自動折り返しのトグル
    {
      mode = "n";
      key = "<leader>uw";
      action = "<cmd>set wrap!<CR>";
      options.desc = "Toggle line wrap";
    }
    # タブ・行末スペース・改行位置の可視化トグル
    {
      mode = "n";
      key = "<leader>ul";
      action = "<cmd>set list!<CR>";
      options.desc = "Toggle invisible characters";
    }
    {
      mode = "n";
      key = "<leader>Q";
      action = "<cmd>qa!<CR>";
      options.desc = "Force quit all";
    }
  ];
}
