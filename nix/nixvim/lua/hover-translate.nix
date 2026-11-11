{ pkgs, ... }:

{
  # translate バックエンド用の CLI (Google 翻訳を API キーなしで叩ける)
  extraPackages = [ pkgs.translate-shell ];

  extraConfigLuaPost = ''
    -- LSP hover の内容を日本語に翻訳してフロート表示する (issue #138)
    --
    -- バックエンド (vim.g.hover_translate_backend で切替、:HoverTranslateBackend でも可):
    --   "trans"  : translate-shell (Google 翻訳, APIキー不要, 速い)
    --   "claude" : claude -p (Claude Code CLI, 高品質/コードブロック保持が得意, 数秒かかる)  ← デフォルト
    --   "deepl"  : DeepL API (環境変数 DEEPL_AUTH_KEY が必要, 無料枠あり)
    --
    -- K で自動翻訳するかは vim.g.hover_translate_auto (:HoverTranslateToggleAuto, デフォルト ON)
    do
      local M = {}
      _G.HoverTranslate = M

      if vim.g.hover_translate_backend == nil then
        vim.g.hover_translate_backend = "claude"
      end
      -- claude バックエンドで使うモデル (claude -p --model に渡す値)
      if vim.g.hover_translate_claude_model == nil then
        vim.g.hover_translate_claude_model = "haiku"
      end
      if vim.g.hover_translate_auto == nil then
        vim.g.hover_translate_auto = true
      end

      local cache = {}
      local FOCUS_ID = "hover_translate"

      -- markdown を「コードブロック」と「文章」に分割する
      local function split_segments(lines)
        local segs, cur, in_code = {}, {}, false
        local function flush(kind)
          if #cur > 0 then
            table.insert(segs, { kind = kind, lines = cur })
            cur = {}
          end
        end
        for _, l in ipairs(lines) do
          if l:match("^%s*```") then
            if in_code then
              table.insert(cur, l)
              flush("code")
              in_code = false
            else
              flush("text")
              table.insert(cur, l)
              in_code = true
            end
          else
            table.insert(cur, l)
          end
        end
        flush(in_code and "code" or "text")
        return segs
      end

      local function strip_trailing_newlines(s)
        return (s:gsub("%s+$", ""))
      end

      -- 失敗時のメッセージ。CLI によってはエラーを stdout に出す (claude など) ので両方含める
      local function format_error(name, r)
        local parts = { name .. " failed (exit " .. tostring(r.code) .. ")" }
        for _, out in ipairs({ r.stdout, r.stderr }) do
          out = strip_trailing_newlines(out or "")
          if out ~= "" then
            table.insert(parts, out)
          end
        end
        return table.concat(parts, "\n")
      end

      -- 1つの文章を翻訳する。cb(ok, text)
      local translators = {}

      translators.trans = function(text, cb)
        vim.system({ "trans", "-b", "-no-autocorrect", "-no-ansi", ":ja" }, { stdin = text, text = true }, function(r)
          local out = strip_trailing_newlines(r.stdout or "")
          if r.code ~= 0 or out == "" then
            cb(false, format_error("trans", r))
          else
            cb(true, out)
          end
        end)
      end

      translators.deepl = function(text, cb)
        local key = vim.env.DEEPL_AUTH_KEY
        if not key or key == "" then
          return cb(false, "DEEPL_AUTH_KEY is not set")
        end
        -- 無料キーは末尾が ":fx"
        local host = key:match(":fx$") and "api-free.deepl.com" or "api.deepl.com"
        local body = vim.json.encode({ text = { text }, target_lang = "JA" })
        vim.system({
          "curl", "-sS", "-X", "POST", "https://" .. host .. "/v2/translate",
          "-H", "Authorization: DeepL-Auth-Key " .. key,
          "-H", "Content-Type: application/json",
          "--data-binary", "@-",
        }, { stdin = body, text = true }, function(r)
          local ok, decoded = pcall(vim.json.decode, r.stdout or "")
          if r.code == 0 and ok and decoded.translations and decoded.translations[1] then
            cb(true, decoded.translations[1].text)
          else
            cb(false, format_error("deepl", r))
          end
        end)
      end

      -- claude はコードブロック込みの markdown 全体をまとめて渡す (分割不要)
      local CLAUDE_PROMPT = table.concat({
        "Translate the following Markdown (LSP hover documentation) into natural Japanese.",
        "Keep code blocks, inline code, identifiers, and Markdown structure exactly as they are.",
        "Output only the translated Markdown, with no preface or explanation.",
      }, " ")

      translators.claude = function(text, cb)
        vim.fn.mkdir(vim.fn.stdpath("cache"), "p")
        vim.system({ "claude", "-p", "--model", vim.g.hover_translate_claude_model or "haiku", CLAUDE_PROMPT }, {
          stdin = text,
          text = true,
          -- プロジェクトの CLAUDE.md 等を読ませないよう、無関係なディレクトリで実行
          cwd = vim.fn.stdpath("cache"),
        }, function(r)
          local out = strip_trailing_newlines(r.stdout or "")
          if r.code ~= 0 or out == "" then
            cb(false, format_error("claude", r))
          else
            cb(true, out)
          end
        end)
      end

      -- markdown 行配列を翻訳する。cb(ok, lines_or_err)
      local function translate_lines(lines, backend, cb)
        local key = backend .. "\0" .. table.concat(lines, "\n")
        if cache[key] then
          return cb(true, cache[key])
        end
        local tr = translators[backend]
        if not tr then
          return cb(false, "unknown backend: " .. tostring(backend))
        end

        local function done(ok, result)
          vim.schedule(function()
            if ok then
              cache[key] = result
            end
            cb(ok, result)
          end)
        end

        if backend == "claude" then
          tr(table.concat(lines, "\n"), function(ok, out)
            done(ok, ok and vim.split(out, "\n", { plain = true }) or out)
          end)
          return
        end

        -- コードブロック以外の文章部分だけを並列で翻訳して、元の順序で組み立てる
        local segs = split_segments(lines)
        local pending, failed = 0, nil
        local function finish()
          if failed then
            return done(false, failed)
          end
          local out = {}
          for _, s in ipairs(segs) do
            vim.list_extend(out, s.result or s.lines)
          end
          done(true, out)
        end
        for _, s in ipairs(segs) do
          local text = table.concat(s.lines, "\n")
          if s.kind == "text" and text:match("%a") then
            pending = pending + 1
            tr(text, function(ok, out)
              if ok then
                s.result = vim.split(out, "\n", { plain = true })
              else
                failed = failed or out
              end
              pending = pending - 1
              if pending == 0 then
                finish()
              end
            end)
          end
        end
        if pending == 0 then
          finish()
        end
      end
      M.translate_lines = translate_lines

      local function open_float(lines)
        return vim.lsp.util.open_floating_preview(lines, "markdown", {
          focus_id = FOCUS_ID,
          border = "rounded",
          max_width = math.floor(vim.o.columns * 0.6),
          max_height = math.floor(vim.o.lines * 0.6),
        })
      end

      -- 既に開いている翻訳フロートの中身を差し替える (カーソル移動で閉じていたら何もしない)
      local function replace_float(win, lines)
        if not (win and vim.api.nvim_win_is_valid(win)) then
          return
        end
        local buf = vim.api.nvim_win_get_buf(win)
        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false
        local width = 0
        for _, l in ipairs(lines) do
          width = math.max(width, vim.fn.strdisplaywidth(l))
        end
        width = math.min(math.max(width, 20), math.floor(vim.o.columns * 0.6))
        vim.api.nvim_win_set_config(win, { width = width })
        local height = vim.api.nvim_win_text_height(win, {}).all
        vim.api.nvim_win_set_config(win, { height = math.min(height, math.floor(vim.o.lines * 0.6)) })
      end

      -- hover を取得 → 原文を即表示 → 翻訳が終わったら差し替え
      function M.hover(opts)
        opts = opts or {}
        local backend = opts.backend or vim.g.hover_translate_backend
        local bufnr = vim.api.nvim_get_current_buf()
        local win = vim.api.nvim_get_current_win()

        vim.lsp.buf_request_all(bufnr, "textDocument/hover", function(client)
          return vim.lsp.util.make_position_params(win, client.offset_encoding)
        end, function(results)
          local lines = {}
          for _, res in pairs(results) do
            if res.result and res.result.contents then
              local l = vim.lsp.util.convert_input_to_markdown_lines(res.result.contents)
              if #lines > 0 and #l > 0 then
                table.insert(lines, "---")
              end
              vim.list_extend(lines, l)
            end
          end
          -- 先頭/末尾の空行を除去
          while lines[1] == "" do table.remove(lines, 1) end
          while lines[#lines] == "" do table.remove(lines) end
          if #lines == 0 then
            vim.notify("No hover information", vim.log.levels.INFO)
            return
          end

          local _, float_win = open_float(vim.list_extend(vim.deepcopy(lines), { "", "_⏳ translating (" .. backend .. ")..._" }))
          translate_lines(lines, backend, function(ok, result)
            if ok then
              replace_float(float_win, result)
            else
              replace_float(float_win, lines)
              vim.notify("hover translate failed: " .. tostring(result), vim.log.levels.WARN)
            end
          end)
        end)
      end

      -- K 用: 自動翻訳ONなら翻訳hover、OFFなら通常hover
      function M.k()
        if vim.g.hover_translate_auto then
          M.hover()
        else
          vim.lsp.buf.hover()
        end
      end

      vim.api.nvim_create_user_command("HoverTranslate", function(a)
        M.hover({ backend = a.args ~= "" and a.args or nil })
      end, {
        nargs = "?",
        complete = function() return vim.tbl_keys(translators) end,
        desc = "LSP hover を翻訳して表示",
      })
      vim.api.nvim_create_user_command("HoverTranslateBackend", function(a)
        if a.args == "" then
          vim.notify("hover translate backend: " .. vim.g.hover_translate_backend)
        elseif translators[a.args] then
          vim.g.hover_translate_backend = a.args
          vim.notify("hover translate backend -> " .. a.args)
        else
          vim.notify("unknown backend: " .. a.args, vim.log.levels.ERROR)
        end
      end, {
        nargs = "?",
        complete = function() return vim.tbl_keys(translators) end,
        desc = "hover 翻訳のバックエンドを切替",
      })
      vim.api.nvim_create_user_command("HoverTranslateToggleAuto", function()
        vim.g.hover_translate_auto = not vim.g.hover_translate_auto
        vim.notify("K auto translate: " .. (vim.g.hover_translate_auto and "ON" or "OFF"))
      end, { desc = "K で自動翻訳するかを切替" })
    end
  '';
}
