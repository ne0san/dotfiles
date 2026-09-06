{ ... }:

{
  # ========================================
  # Colorscheme (extraConfigLuaでonedarkpro自体をsetup - モジュールにバグがあるため)
  # ========================================
  colorschemes.onedark = {
    enable = true;
  };

  highlight = {
    RainbowRed.fg = "#E06C75";
    RainbowYellow.fg = "#E5C07B";
    RainbowBlue.fg = "#61AFEF";
    RainbowOrange.fg = "#D19A66";
    RainbowGreen.fg = "#98C379";
    RainbowViolet.fg = "#C678DD";
    RainbowCyan.fg = "#56B6C2";

    # gitblame の文字色がコメントと被って見づらいため専用のハイライトを定義
    GitBlame = {
      fg = "#4A88C7";
      italic = true;
    };

    # 分割ウィンドウの境目をデフォルトより少しだけはっきりさせる
    WinSeparator.fg = "#5C6370";

    # ミニマップの境目は自己主張を弱めた色にする(背景に近い色)
    NeominimapBorder.fg = "#3B4048";

    # ヤンク時のハイライトが検索ハイライト(IncSearch)と同色で紛らわしいため専用の色を定義
    YankHighlight = {
      bg = "#98C379";
      fg = "#282C34";
    };
  };

  extraConfigLua = ''
    -- OneDarkPro setup
    require("onedarkpro").setup({
      options = {
        transparency = false,
        terminal_colors = true,
        cursorline = true,
      }
    })

    -- 型注釈などのインレイヒントはデフォルトでCommentと同じ文字色になっており、
    -- 通常のコメントと見分けづらいため、背景色だけ少し暗くして区別する。
    -- 特定の色を決め打ちすると別のカラーテーマで浮いてしまうので、
    -- その時点のNormalの背景色を基準に暗くするだけにとどめ、文字色には触れない。
    local function darken_inlay_hint_bg()
      local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
      if not normal.bg then
        return
      end
      -- NeovimはLuaJIT(Lua 5.1相当)のため >> や & といったLua 5.3以降のビット演算子は使えず、
      -- 算術演算(除算・剰余)でRGB各成分を取り出す。
      local darken_ratio = 0.8
      local r = math.floor(math.floor(normal.bg / 65536) % 256 * darken_ratio)
      local g = math.floor(math.floor(normal.bg / 256) % 256 * darken_ratio)
      local b = math.floor(normal.bg % 256 * darken_ratio)

      local hint = vim.api.nvim_get_hl(0, { name = 'LspInlayHint', link = false })
      hint.bg = r * 65536 + g * 256 + b
      vim.api.nvim_set_hl(0, 'LspInlayHint', hint)
    end
    darken_inlay_hint_bg()
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('darken_inlay_hint_bg', {}),
      callback = darken_inlay_hint_bg,
      desc = 'カラーテーマ変更時にインレイヒントの背景を追従させて再計算する',
    })
  '';
}
