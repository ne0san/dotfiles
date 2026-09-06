{ ... }:

{
  userCommands = {
    # snacks.bufdeleteで:bdを上書き
    Bd = {
      command.__raw = "function() Snacks.bufdelete() end";
      force = true;
    };

    # 相対パスをクリップボードにコピー
    CopyRelPath.command.__raw = ''
      function()
        local path = vim.fn.expand('%')
        vim.fn.setreg('+', path)
        vim.notify('Copied: ' .. path, vim.log.levels.INFO)
      end
    '';

    # 絶対パスもついでに！
    CopyAbsPath.command.__raw = ''
      function()
        local path = vim.fn.expand('%:p')
        vim.fn.setreg('+', path)
        vim.notify('Copied: ' .. path, vim.log.levels.INFO)
      end
    '';

    # ファイル名だけコピーしたいときもあるよね
    CopyFileName.command.__raw = ''
      function()
        local path = vim.fn.expand('%:t')
        vim.fn.setreg('+', path)
        vim.notify('Copied: ' .. path, vim.log.levels.INFO)
      end
    '';

    PasteNewBuffer.command.__raw = ''
      function()
        -- クリップボードの内容を取得
        local content = vim.fn.getreg('+')
        -- 新規バッファ作成
        vim.cmd('enew')

        -- クリップボードの内容を貼り付け
        vim.api.nvim_put(vim.split(content, '\n'), 'l', true, true)

        vim.notify('Created new buffer from clipboard', vim.log.levels.INFO)
      end
    '';

    # バッファ比較
    DiffBuffers.command.__raw = ''
      function()
        local current_buf = vim.api.nvim_get_current_buf()
        local buffers = vim.fn.getbufinfo({buflisted = 1})
        local buf_names = {}

        for _, buf in ipairs(buffers) do
          if buf.bufnr ~= current_buf then
            table.insert(buf_names, buf.name ~= "" and buf.name or '[No Name]')
          end
        end

        if #buf_names == 0 then
          vim.notify('No other buffers to compare!', vim.log.levels.WARN)
          return
        end

        vim.ui.select(buf_names, {
          prompt = 'Select buffer to compare:',
        }, function(choice)
          if choice then
            vim.cmd('vertical diffsplit ' .. vim.fn.fnameescape(choice))
          end
        end)
      end
    '';

    DiffOff.command.__raw = ''
      function()
        vim.cmd('diffoff!')
      end
    '';

    # どのウィンドウからも表示されていないバッファを全削除
    DeleteHiddenBuffers.command.__raw = ''
      function()
        local visible_bufs = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          visible_bufs[vim.api.nvim_win_get_buf(win)] = true
        end

        local deleted = 0
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf)
             and vim.bo[buf].buflisted
             and not visible_bufs[buf] then
            Snacks.bufdelete(buf)
            deleted = deleted + 1
          end
        end

        vim.notify('Deleted ' .. deleted .. ' hidden buffer(s)', vim.log.levels.INFO)
      end
    '';

    # 現在行のGitHub URLをクリップボードにコピー
    CopyGitHubLineURL.command.__raw = ''
      function()
        local file = vim.fn.expand('%:p')
        local line = vim.fn.line('.')
        local remote = vim.fn.system('git remote get-url origin 2>/dev/null'):gsub('%s+$', "")
        if remote == "" then
          vim.notify('No git remote found', vim.log.levels.WARN)
          return
        end
        local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD 2>/dev/null'):gsub('%s+$', "")
        local root = vim.fn.system('git rev-parse --show-toplevel 2>/dev/null'):gsub('%s+$', "")
        local rel_path = file:sub(#root + 2)
        -- SSH URL を HTTPS に変換
        remote = remote:gsub('^git@github%.com:', 'https://github.com/')
        remote = remote:gsub('%.git$', "")
        local url = remote .. '/blob/' .. branch .. '/' .. rel_path .. '#L' .. line
        vim.fn.setreg('+', url)
        vim.notify('Copied: ' .. url, vim.log.levels.INFO)
      end
    '';

    # 現在行のGitHub URL (master固定) をクリップボードにコピー
    CopyGitHubMasterLineURL.command.__raw = ''
      function()
        local file = vim.fn.expand('%:p')
        local line = vim.fn.line('.')
        local remote = vim.fn.system('git remote get-url origin 2>/dev/null'):gsub('%s+$', "")
        if remote == "" then
          vim.notify('No git remote found', vim.log.levels.WARN)
          return
        end
        local root = vim.fn.system('git rev-parse --show-toplevel 2>/dev/null'):gsub('%s+$', "")
        local rel_path = file:sub(#root + 2)
        remote = remote:gsub('^git@github%.com:', 'https://github.com/')
        remote = remote:gsub('%.git$', "")
        local url = remote .. '/blob/master/' .. rel_path .. '#L' .. line
        vim.fn.setreg('+', url)
        vim.notify('Copied: ' .. url, vim.log.levels.INFO)
      end
    '';

    # フォーカス行の診断メッセージをクリップボードにコピー
    CopyDiagnostic.command.__raw = ''
      function()
        local lnum = vim.fn.line('.') - 1
        local diagnostics = vim.diagnostic.get(0, { lnum = lnum })
        if #diagnostics == 0 then
          vim.notify('No diagnostics on this line', vim.log.levels.INFO)
          return
        end
        local severity_names = { 'ERROR', 'WARN', 'INFO', 'HINT' }
        local messages = {}
        for _, d in ipairs(diagnostics) do
          local sev = severity_names[d.severity] or 'INFO'
          table.insert(messages, string.format('[%s] %s', sev, d.message))
        end
        local msg = table.concat(messages, '\n')
        vim.fn.setreg('+', msg)
        vim.notify('Copied: ' .. msg, vim.log.levels.INFO)
      end
    '';
  };

  # userCommandsではコマンドの略語(abbreviation)は扱えないため、:bd/:bdeleteの
  # 上書きはextraConfigLuaのまま残す
  extraConfigLua = ''
    vim.cmd('cnoreabbrev bd lua Snacks.bufdelete()')
    vim.cmd('cnoreabbrev bdelete lua Snacks.bufdelete()')
  '';
}
