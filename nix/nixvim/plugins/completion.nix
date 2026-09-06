{ ... }:

{
  plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
          { name = "luasnip"; }
        ];
        mapping = {
          "<M-Tab>" = "cmp.mapping.complete()";
          "<M-e>" = "cmp.mapping.close()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          # 補完メニュー非表示時はシフト幅ぶんインデントを1つ消す(dedent)
          "<S-Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-d>", true, true, true), "n", true)
              end
            end, {'i', 's'})
          '';
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
        };
      };
    };

    # Snippets
    luasnip.enable = true;
  };
}
