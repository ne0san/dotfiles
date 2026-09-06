{ ... }:

{
  extraConfigLuaPost = ''
    -- fsautocomplete の UnusedDeclarationsAnalyzer は、コンピュテーション式内の
    -- let!/and!/use!/do!/match! 等の束縛を実際に使っていても誤って
    -- 「This value is unused」の[HINT]を出すことがある(F#コンパイラ側の既知の制限)。
    -- 分析自体は有効なまま保ち、該当行がCEキーワードを含む場合の
    -- unused系Hintだけをクライアント側で除外する。
    do
      local orig_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        if result and result.diagnostics then
          local client = vim.lsp.get_client_by_id(ctx.client_id)
          if client and client.name == "fsautocomplete" then
            local bufnr = vim.uri_to_bufnr(result.uri)
            result.diagnostics = vim.tbl_filter(function(d)
              local is_unused_hint = d.severity == vim.diagnostic.severity.HINT
                and d.message
                and d.message:lower():find("unused", 1, true)
              if not is_unused_hint then
                return true
              end
              if not vim.api.nvim_buf_is_loaded(bufnr) then
                return true
              end
              local line = vim.api.nvim_buf_get_lines(bufnr, d.range.start.line, d.range.start.line + 1, false)[1] or ""
              local is_ce_binding = line:find("let!") or line:find("and!") or line:find("use!") or line:find("do!") or line:find("match!")
              return not is_ce_binding
            end, result.diagnostics)
          end
        end
        orig_handler(err, result, ctx, config)
      end
    end

    -- F#: VSCode Ionideのように "///" を打つとXMLドキュメントコメントの
    -- テンプレート(summary/param/returns)をよしなに自動生成する。
    -- fsautocomplete側に対応する専用LSPエンドポイントが無いため、
    -- 直下の宣言行を簡易パースしてクライアント側で生成する。
    -- 対応できるのは "(name: Type)" 形式の型注釈付き引数のみで、
    -- 型注釈のないカリー化引数(let f x y = ...)は<param>を生成しない。
    do
      local function fsharp_generate_doc_comment(bufnr, lnum)
        local total_lines = vim.api.nvim_buf_line_count(bufnr)
        local sig_line = nil
        local scan = lnum -- 0-indexed: lnum行目(1-indexed)の次の行から
        while scan < total_lines do
          local text = vim.api.nvim_buf_get_lines(bufnr, scan, scan + 1, false)[1] or ""
          local trimmed = vim.trim(text)
          if trimmed ~= "" and not trimmed:match("^///") then
            sig_line = text
            break
          end
          scan = scan + 1
        end

        local doc_lines = { "/// <summary>", "///", "/// </summary>" }
        if sig_line then
          for pname in sig_line:gmatch("%(%s*([%a_][%w_']*)%s*:[^%(%)]*%)") do
            table.insert(doc_lines, string.format('/// <param name="%s"></param>', pname))
          end
          if sig_line:match("%)%s*:%s*[%a_][%w_%.<>,%s]*%s*=") then
            table.insert(doc_lines, "/// <returns></returns>")
          end
        end

        local indent = (vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""):match("^%s*") or ""
        for i, l in ipairs(doc_lines) do
          doc_lines[i] = indent .. l
        end
        vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, doc_lines)
        vim.api.nvim_win_set_cursor(0, { lnum + 1, #doc_lines[2] })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "fsharp",
        group = vim.api.nvim_create_augroup("FSharpDocComment", { clear = true }),
        callback = function(args)
          vim.api.nvim_create_autocmd("TextChangedI", {
            buffer = args.buf,
            group = vim.api.nvim_create_augroup("FSharpDocCommentBuf" .. args.buf, { clear = true }),
            callback = function()
              -- vim.trim()で前後の空白を除去して比較すると、生成済みテンプレートの
              -- 空行(2行目の"///")に末尾スペースを入力しただけでも一致してしまい、
              -- 二重生成を招く。末尾に何も無い完全な"///"の場合のみトリガーする。
              if vim.api.nvim_get_current_line():match("^%s*///$") then
                local lnum = vim.api.nvim_win_get_cursor(0)[1]
                fsharp_generate_doc_comment(args.buf, lnum)
              end
            end,
          })
        end,
      })
    end

    -- F#: インデントをIonide-vim(indent/fsharp.vim)に強制的に委ねる。
    -- nvim-treesitterは2026年4月にmainブランチへ全面書き換えられてアーカイブされ、
    -- 従来の`indent.enable/disable`という宣言的な言語別設定が効かなくなり、
    -- indentexprがグローバルにtreesitter側の関数で上書きされてしまう
    -- (indent/fsharp.vimがbuiltinのindent.vimローダーより先に評価されず、
    -- 一切読み込まれないケースも確認された)。
    -- そのため、この設定ファイルの中で最後にFileTypeへ登録して強制的に
    -- indent/fsharp.vimを読み込み、indentexprを上書きし直す。
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "fsharp",
      group = vim.api.nvim_create_augroup("FSharpForceIndent", { clear = true }),
      callback = function(args)
        -- indent/fsharp.vim内のb:did_indentガードで再読み込みがスキップ
        -- されないよう、先にクリアしてから強制的に読み込む
        vim.cmd("unlet! b:did_indent")
        vim.cmd("runtime! indent/fsharp.vim")
        if vim.fn.exists("*FSharpIndent") == 1 then
          vim.bo[args.buf].indentexpr = "FSharpIndent()"
        end
      end,
    })
  '';
}
