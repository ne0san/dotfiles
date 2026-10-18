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

    -- snacks.picker: 対応するファイルが未保存の変更を持つバッファとして
    -- 開かれている場合に ● アイコンを表示するフォーマッタ。
    -- (各ピッカーの opts.format に直接渡す。起動時に自動で開かれる
    --  explorer のような「使い回されるピッカー」は、setup() 完了後に
    --  Snacks.picker.format テーブルを書き換える方式だと、その書き換えが
    --  適用される前に元のフォーマッタを捕まえてしまうため反映されない。
    --  opts に直接渡すことで、ピッカー生成のタイミングに関係なく確実に効かせる)
    local function with_unsaved_marker(base_format_name)
      return function(item, picker)
        local ret = Snacks.picker.format[base_format_name](item, picker)
        local bufnr = item.buf
        if not bufnr then
          local path = Snacks.picker.util.path(item)
          bufnr = path and vim.fn.bufnr(path) or nil
        end
        if bufnr and bufnr > 0 and vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].modified then
          ret[#ret + 1] = { " " }
          ret[#ret + 1] = { "●", "SnacksPickerBufFlags" }
        end
        return ret
      end
    end

    _G.snacks_picker_unsaved_file_format = with_unsaved_marker("file")
    _G.snacks_picker_unsaved_buffer_format = with_unsaved_marker("buffer")
  '';
}
