{ ... }:

{
  # extraConfigLuaPre: 他のキーマップ/プラグイン設定より前に読み込まれる必要がある
  # グローバルヘルパー関数やランタイムワークアラウンド
  extraConfigLuaPre = ''
    -- yw/yW/dw/dW を単語の先頭から開始するようにする
    -- (カーソルが単語の途中にあっても、その単語の先頭まで戻ってから操作する)
    _G.smart_word_op = function(op, big)
      return function()
        local count = vim.v.count1
        local col = vim.fn.col('.')
        local char = vim.fn.getline('.'):sub(col, col)
        if char ~= "" and not char:match('%s') then
          local boundary = big and [[\(^\|\s\)\zs\S]] or [[\<]]
          local pos = vim.fn.searchpos(boundary, 'bcn')
          if pos[1] ~= 0 then
            vim.fn.cursor(pos[1], pos[2])
          end
        end
        vim.cmd('normal! ' .. count .. op .. (big and 'W' or 'w'))
      end
    end

    -- nvim-treesitter と Neovim 0.11.x のバージョン不一致対応
    -- nvim-treesitter (新) が Neovim 本体に委譲した述語を手動登録する
    vim.treesitter.query.add_predicate("is-not?", function()
      return true
    end, { force = true })
    vim.treesitter.query.add_predicate("is?", function()
      return true
    end, { force = true })

    vim.opt.shortmess:append("I")
  '';
}
