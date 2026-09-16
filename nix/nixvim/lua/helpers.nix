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

    -- <leader>Q (Force quit all) 実行前に未保存バッファがあれば保存するか確認する
    _G.confirm_quit_all = function()
      local unsaved_names = {}
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
          local name = vim.api.nvim_buf_get_name(buf)
          if name == "" then
            name = "[No Name]"
          else
            name = vim.fn.fnamemodify(name, ":.")
          end
          table.insert(unsaved_names, name)
        end
      end

      if #unsaved_names == 0 then
        vim.cmd("qa!")
        return
      end

      local buffer_list = "  - " .. table.concat(unsaved_names, "\n  - ")
      local message = "There are unsaved changes in:\n" .. buffer_list .. "\n\nSave before quitting?"

      -- confirm() はメッセージの行数ぶん 'cmdheight' の高さが必要で、足りないと
      -- (特に2回目以降の呼び出しで)ダイアログの枠だけが描画されメッセージ本文が
      -- 表示されないことがあるため、メッセージの行数に合わせて一時的に広げる
      local message_lines = select(2, message:gsub("\n", "\n")) + 1
      local prev_cmdheight = vim.o.cmdheight
      vim.o.cmdheight = math.max(prev_cmdheight, message_lines + 2)
      vim.cmd("redraw")

      local ok_confirm, choice = pcall(vim.fn.confirm, message, "&Yes\n&No\n&Cancel", 1)
      vim.o.cmdheight = prev_cmdheight
      if not ok_confirm then
        return
      end

      if choice == 1 then
        local ok, err = pcall(vim.cmd, "wa")
        if not ok then
          vim.notify("Save failed, aborting quit: " .. err, vim.log.levels.ERROR)
          return
        end
        vim.cmd("qa!")
      elseif choice == 2 then
        vim.cmd("qa!")
      end
      -- choice == 3 (Cancel) or 0 (Esc/closed dialog): do nothing
    end
  '';
}
