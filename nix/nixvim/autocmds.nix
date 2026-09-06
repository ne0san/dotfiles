{ ... }:

{
  autoCmd = [
    {
      event = "FileType";
      pattern = [
        "NvimTree"
        "qf"
        "help"
        "aerial"
        "snacks_dashboard"
      ];
      callback = {
        __raw = ''
          function()
            vim.opt_local.buflisted = false
          end
        '';
      };
    }
    {
      event = "QuitPre";
      callback.__raw = ''
        function()
          -- 現在のウィンドウ番号を取得
          local current_win = vim.api.nvim_get_current_win()
          -- すべてのウィンドウをループして調べる
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            -- カレント以外を調査
            if win ~= current_win then
              local buf = vim.api.nvim_win_get_buf(win)
              -- buftypeが空文字（通常のバッファ）があればループ終了
              if vim.bo[buf].buftype == "" then
                return
              end
            end
          end
          -- ここまで来たらカレント以外がすべて特殊ウィンドウということなので
          -- カレント以外をすべて閉じる
          vim.cmd.only({ bang = true })
          -- この後、ウィンドウ1つの状態でquitが実行されるので、Vimが終了する
        end
      '';
      desc = "Close all special buffers and quit Neovim";
    }
    {
      event = [
        "WinScrolled"
        "BufWinEnter"
        "CursorMoved"
        "CursorMovedI"
      ];
      callback.__raw = ''
        function()
          local ok, context = pcall(require, "treesitter-context.context")
          if not ok then
            return
          end
          local winid = vim.api.nvim_get_current_win()
          local _, lines = context.get(winid)
          local height = lines and #lines or 0
          vim.wo[winid].scrolloff = height

          -- scrolloffの更新は次回のカーソル移動から効くため、
          -- ネストが深くなった直後の1回はまだ古いscrolloffで
          -- スクロールされ、ヘッダと重なってしまう。
          -- 検出した瞬間にビューを直接補正して即座に解消する。
          if height > 0 then
            local winline = vim.fn.winline()
            if winline <= height then
              local view = vim.fn.winsaveview()
              view.topline = view.topline + (height - winline + 1)
              vim.fn.winrestview(view)
            end
          end
        end
      '';
      desc = "ヘッダ追従(treesitter-context)の実際の高さに合わせてscrolloffを動的に調整し、カーソルとの重なりを防ぐ";
    }
    {
      event = [
        "FocusGained"
        "BufEnter"
        "CursorHold"
        "CursorHoldI"
        "TextChangedT"
      ];
      pattern = "*";
      callback.__raw = ''
        function()
          -- checktime()は引数なしで呼ぶと全バッファを対象にするため、
          -- 現在のバッファ種別(ターミナル等)によらず呼んでよい。
          -- 未保存の変更があるバッファは自動的にスキップされる(autoreadの仕様)。
          -- TextChangedTはnvim内蔵ターミナルへの出力(コマンド実行結果)を
          -- 検知するためのイベントで、ターミナルからファイルを変更した場合に
          -- フォーカス移動を待たず反映させるのに必要。
          -- ただしTextChangedTはジョブ出力を処理するfast event/textlockの
          -- コンテキスト内で発火し、その場でcheckttimeを呼んでも失敗したり
          -- 他ウィンドウの表示が再描画されなかったりするため、
          -- vim.scheduleでメインループに逃がしてから実行し、
          -- 明示的にredrawして即座に画面へ反映させる。
          vim.schedule(function()
            vim.cmd("checktime")
            vim.cmd("redraw")
          end)
        end
      '';
      desc = "編集中(未保存の変更なし)であればnvim外部(ターミナル内含む)でのファイル変更を自動でバッファに反映する";
    }
    {
      event = "LspAttach";
      callback.__raw = ''
        function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
        end
      '';
      desc = "LSPが対応していれば型注釈などのインレイヒントを自動的に有効化する（VSCode Ionideのような表示）";
    }
    {
      event = "LspAttach";
      callback.__raw = ''
        function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          -- fsautocompleteのセマンティックトークンは、型注釈なしの多段メソッド
          -- チェーン(page.Locator(...).Firstのような)を含むバッファでデコード処理が
          -- 極端に重くなり、nvimがフリーズする不具合を確認したため無効化する。
          -- 構文ハイライトはtreesitter(fsharpグラマー)で代替できるため実害はない。
          if client and client.name == "fsautocomplete" then
            client.server_capabilities.semanticTokensProvider = nil
            vim.lsp.semantic_tokens.enable(false, { bufnr = args.buf })
          end
        end
      '';
      desc = "fsautocompleteのセマンティックトークンを無効化(フリーズ対策)";
    }
    {
      event = "TermOpen";
      callback.__raw = ''
        function(ev)
          -- lazygit/jjui/Claude Code 以外、かつ direnv 管理下のディレクトリでのみ direnv reload を実行
          local name = vim.api.nvim_buf_get_name(ev.buf):lower()
          if name:match("lazygit") or name:match("jjui") or name:match("claude") then return end
          if vim.fn.findfile(".envrc", ".;") == "" then return end
          local chan = vim.b[ev.buf].terminal_job_id
          if chan and chan > 0 then
            vim.defer_fn(function()
              pcall(vim.fn.chansend, chan, "direnv reload\n")
            end, 500)
          end
        end
      '';
      desc = "ターミナル起動時にdirenv管理下のディレクトリならdirenv reloadを実行する";
    }
    {
      event = "TextYankPost";
      pattern = "*";
      callback.__raw = ''
        function()
          vim.hl.on_yank({
            higroup = "YankHighlight", -- ハイライトグループ（検索ハイライトと区別するため専用色）
            timeout = 100,             -- 表示時間（ミリ秒）
          })
        end
      '';
      desc = "ヤンク時に自動でハイライト";
    }
  ];
}
