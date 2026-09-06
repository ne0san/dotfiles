{ ... }:

{
  globals = {
    mapleader = " ";
    maplocalleader = ",";
    # Ionide-vimはインデント(indent/fsharp.vim)目的でのみ導入し、
    # LSPクライアントはnixvim側のfsautocomplete設定と二重起動するため無効化する
    "fsharp#backend" = "disable";

    # neominimap.nvim setup (v3以降は vim.g.neominimap で設定)
    neominimap = {
      auto_enable = false;
      float = {
        minimap_width = 14;
        window_border = "single"; # 境目を描画させる(色は NeominimapBorder ハイライトで指定)
      };
      winopt.__raw = ''
        function(opt, _winid)
          opt.signcolumn = "no"
        end
      '';
    };
  };

  opts = {
    # 行番号
    number = true;
    relativenumber = true;
    cursorline = true;

    # サインカラム
    signcolumn = "yes";

    # 折り返しなし
    wrap = false;

    # スペル無効
    spell = false;

    # True Color
    termguicolors = true;

    # タブ設定 (デフォルト値。sleuthプラグインがファイルごとに自動判別して上書きする)
    expandtab = true;
    shiftwidth = 2;
    tabstop = 2;

    # 検索
    ignorecase = true;
    smartcase = true;

    # その他
    clipboard = "unnamedplus";
    mouse = "a";
    undofile = true;
    updatetime = 250;
    timeoutlen = 300;
    autoread = true; # 編集中でなければnvim外部での変更を自動でバッファに反映

    # 折りたたみ
    foldlevel = 99; # 最初は全部開いた状態
    foldlevelstart = 99; # ファイル開いた時も全部開く

    # 分割時の新ウィンドウ配置（vsplitは右、splitは下に新ウィンドウを開く）
    splitright = true;
    splitbelow = true;

    # 不可視文字(タブ・行末スペース・改行位置)の可視化
    list = true;
    listchars = {
      tab = "▸ ";
      trail = "·";
      nbsp = "␣";
      extends = "›";
      precedes = "‹";
      eol = "↴";
    };
  };
}
