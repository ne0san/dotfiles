{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # ========================================
    # Global Options
    # ========================================
    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };
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
    ];
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

      # タブ設定
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

      # 折りたたみ
      foldlevel = 99; # 最初は全部開いた状態
      foldlevelstart = 99; # ファイル開いた時も全部開く
    };

    # ========================================
    # Colorscheme (extraPluginsで設定 - モジュールにバグがあるため)
    # ========================================
    colorschemes.onedark = {
      enable = true;
    };
    # ========================================
    # Plugins
    # ========================================
    plugins = {
      # Treesitter
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
        # Lua, Rust, TypeScript + 基本的な言語
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          lua
          rust
          typescript
          tsx
          javascript
          json
          html
          css
          nix
          markdown
          markdown_inline
          vim
          vimdoc
          bash
          yaml
          toml
          go
        ];
      };

      treesitter-context = {
        enable = true;
        settings = {
          max_lines = 3; # 表示する最大行数
          min_window_height = 0;
          mode = "topline"; # or "cursor"
        };
      };

      # LSP
      lsp = {
        enable = true;
        servers = {
          # Lua
          lua_ls = {
            enable = true;
            settings = {
              Lua = {
                diagnostics = {
                  globals = [ "vim" ];
                };
              };
            };
          };
          # Rust
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          # TypeScript
          ts_ls = {
            enable = true;
          };
          # Nix
          nil_ls = {
            enable = true;
          };
          # go
          gopls = {
            enable = true;
          };
          jsonls = {
            enable = true;
          };
        };
      };

      # Completion
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
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
          };
        };
      };

      # Snippets
      luasnip.enable = true;

      # Which-key (キーバインドヘルプ)
      which-key = {
        enable = true;

        settings = {
          delay = 0;
          win = {
            border = "rounded";
          };
        };
      };

      # Lualine (ステータスライン)
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "onedark";
            globalstatus = true;
          };
        };
      };

      # Bufferline (バッファタブ)
      bufferline = {
        enable = true;
        settings.options = {
          close_command.__raw = "function(bufnum) Snacks.bufdelete(bufnum, { force = true }) end";
          right_mouse_command.__raw = "function(bufnum) Snacks.bufdelete(bufnum) end";
        };
      };

      # Git signs
      gitsigns = {
        enable = true;
      };
      gitblame = {
        enable = true;
        settings = {
          enabled = true;
          delay = 0;
          message_template = "<author>, <date> - <summary>";
          date_format = "%Y-%m-%d %H:%M:%S";
        };
      };
      # Autopairs
      nvim-autopairs = {
        enable = true;
      };

      # Comment
      comment = {
        enable = true;
      };

      # Web devicons
      web-devicons = {
        enable = true;
      };

      # Aerial (Symbols Outline)
      aerial = {
        enable = true;
        settings = {
          backends = [
            "treesitter"
            "lsp"
          ];
          layout = {
            min_width = 30;
            default_direction = "right";
          };
          show_guides = true;
          filter_kind = false;
        };
      };

      # Todo Comments
      todo-comments = {
        enable = true;
      };

      # Notify (通知UI)
      notify = {
        enable = true;
        settings = {
          timeout = 3000;
          render = "default";
          stages = "fade_in_slide_out";
        };
      };

      # Noice (コマンドラインUI改善)
      noice = {
        enable = true;
        settings = {
          lsp = {
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
              "cmp.entry.get_documentation" = true;
            };
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = false;
            lsp_doc_border = false;
          };
        };
      };

      # Smart Splits (ウィンドウリサイズ・移動)
      smart-splits = {
        enable = true;
        settings = {
          ignored_filetypes = [
            "nofile"
            "quickfix"
            "prompt"
          ];
          ignored_buftypes = [ "NvimTree" ];
        };
      };

      # ttiny-inline-diagnostic(インラインで診断メッセージ)
      tiny-inline-diagnostic = {
        enable = true;
        settings = {
          preset = "modern"; # "ghost", "classic", "modern"
          options = {
            show_source = true;
            multilines = true;
          };
        };
      };

      # nvim-ufo lspベースの折りたたみ
      nvim-ufo = {
        enable = true;
      };

      # フォーマッタ
      conform-nvim = {
        enable = true;

        # ファイルタイプごとにフォーマッタを設定
        settings = {
          formatters_by_ft = {
            lua = [ "stylua" ];
            python = [
              "isort"
              "black"
            ];
            javascript = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            nix = [ "alejandra" ];
            go = [ "gofmt" ];
            # 全てのファイルに適用したいやつ
            "*" = [ "trim_whitespace" ];
          };

          # 保存時に自動フォーマット (オプション)
          format_on_save = {
            timeout_ms = 500;
            lsp_format = "fallback";
          };
        };
      };
      auto-session = {
        enable = true;
      };

      modicator = {
        enable = true;
      };

    };

    # ========================================
    # Keymaps
    # ========================================
    keymaps = [
      # ===== 一般 =====
      # ESCでハイライト消去
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
        options.desc = "Clear search highlight";
      }
      # jjでノーマルモードに戻る
      {
        mode = "i";
        key = "jj";
        action = "<Esc>";
        options.desc = "Exit insert mode";
      }

      # ===== comment ======
      {
        mode = "n";
        key = "<leader>/";
        action = "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>";
        options.desc = "Toggle comment";
      }
      {
        mode = "v";
        key = "<leader>/";
        action = "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>";
        options.desc = "Toggle comment (visual)";
      }

      # ===== conform =====
      {
        mode = "n";
        key = "<leader>F";
        action.__raw = ''
          function()
            require('conform').format({ async = true })
          end
        '';
        options = {
          desc = "Format buffer";
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<leader>f";
        action.__raw = ''
          function()
            require('conform').format({ async = true })
          end
        '';
        options.desc = "Format selection";
      }

      # ===== fold =====
      {
        mode = "n";
        key = "<leader>z";
        action = "za";
        options = {
          desc = "Toggle fold";
          silent = true;
        };
      }

      # ===== バッファ操作 =====
      {
        mode = "n";
        key = "]b";
        action = "<cmd>bnext<CR>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "[b";
        action = "<cmd>bprevious<CR>";
        options.desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "<leader>bn";
        action = "<cmd>bnext<CR>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<leader>bp";
        action = "<cmd>bprevious<CR>";
        options.desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "<leader>bf";
        action.__raw = "function() Snacks.picker.buffers() end";
        options.desc = "Find buffers";
      }
      {
        mode = "n";
        key = "<leader>bD";
        action.__raw = "function() Snacks.bufdelete(0, { force = true }) end";
        options = {
          silent = true;
          desc = "Force delete buffer keep window";
        };
      }
      {
        mode = "n";
        key = "<leader>bd";
        action.__raw = "function() Snacks.bufdelete() end";
        options = {
          silent = true;
          desc = "Delete buffer keep window";
        };
      }
      {
        mode = "n";
        key = "<leader>bc";
        action = "<cmd>DiffBuffers<CR>";
        options = {
          silent = true;
          desc = "Compare with another buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bo";
        action = "<cmd>DiffOff<CR>";
        options = {
          silent = true;
          desc = "Turn off diff mode";
        };
      }
      # 差分間の移動
      {
        mode = "n";
        key = "]c";
        action = "]c";
        options = {
          desc = "Next diff";
        };
      }
      {
        mode = "n";
        key = "[c";
        action = "[c";
        options = {
          desc = "Previous diff";
        };
      }
      # ===== ウィンドウ分割 (AstroNvim風) =====
      {
        mode = "n";
        key = "|";
        action = "<cmd>vsplit<CR>";
        options.desc = "Vertical split";
      }
      {
        mode = "n";
        key = "\\";
        action = "<cmd>split<CR>";
        options.desc = "Horizontal split";
      }

      # ===== ウィンドウ操作 (smart-splits) =====
      {
        mode = "n";
        key = "<C-h>";
        action.__raw = "function() require('smart-splits').move_cursor_left() end";
        options.desc = "Move to left window";
      }
      {
        mode = "n";
        key = "<C-j>";
        action.__raw = "function() require('smart-splits').move_cursor_down() end";
        options.desc = "Move to bottom window";
      }
      {
        mode = "n";
        key = "<C-k>";
        action.__raw = "function() require('smart-splits').move_cursor_up() end";
        options.desc = "Move to top window";
      }
      {
        mode = "n";
        key = "<C-l>";
        action.__raw = "function() require('smart-splits').move_cursor_right() end";
        options.desc = "Move to right window";
      }
      {
        mode = "n";
        key = "<M-k>";
        action.__raw = "function() require('smart-splits').resize_up() end";
        options.desc = "Resize window up";
      }
      {
        mode = "n";
        key = "<M-j>";
        action.__raw = "function() require('smart-splits').resize_down() end";
        options.desc = "Resize window down";
      }
      {
        mode = "n";
        key = "<M-h>";
        action.__raw = "function() require('smart-splits').resize_left() end";
        options.desc = "Resize window left";
      }
      {
        mode = "n";
        key = "<M-l>";
        action.__raw = "function() require('smart-splits').resize_right() end";
        options.desc = "Resize window right";
      }
      # ウィンドウ移動 (Shift + 矢印キー)
      {
        mode = "n";
        key = "<S-Left>";
        action.__raw = "function() require('smart-splits').move_cursor_left() end";
        options.desc = "Move to left window";
      }
      {
        mode = "n";
        key = "<S-Down>";
        action.__raw = "function() require('smart-splits').move_cursor_down() end";
        options.desc = "Move to bottom window";
      }
      {
        mode = "n";
        key = "<S-Up>";
        action.__raw = "function() require('smart-splits').move_cursor_up() end";
        options.desc = "Move to top window";
      }
      {
        mode = "n";
        key = "<S-Right>";
        action.__raw = "function() require('smart-splits').move_cursor_right() end";
        options.desc = "Move to right window";
      }

      # ウィンドウサイズ変更 (Alt + Shift + 矢印キー)
      {
        mode = "n";
        key = "<M-S-Up>";
        action.__raw = "function() require('smart-splits').resize_up() end";
        options.desc = "Resize window up";
      }
      {
        mode = "n";
        key = "<M-S-Down>";
        action.__raw = "function() require('smart-splits').resize_down() end";
        options.desc = "Resize window down";
      }
      {
        mode = "n";
        key = "<M-S-Left>";
        action.__raw = "function() require('smart-splits').resize_left() end";
        options.desc = "Resize window left";
      }
      {
        mode = "n";
        key = "<M-S-Right>";
        action.__raw = "function() require('smart-splits').resize_right() end";
        options.desc = "Resize window right";
      }
      # ===== Explorer (snacks.explorer) =====
      {
        mode = "n";
        key = "<leader>e";
        action.__raw = "function() Snacks.explorer() end";
        options.desc = "Toggle file explorer";
      }
      {
        mode = "n";
        key = "<leader>o";
        action.__raw = "function() Snacks.explorer() end";
        options.desc = "Focus file explorer";
      }

      # ===== Finder (snacks.picker) =====
      {
        mode = "n";
        key = "<leader>ff";
        action.__raw = "function() Snacks.picker.files() end";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action.__raw = "function() Snacks.picker.grep() end";
        options.desc = "Live grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action.__raw = "function() Snacks.picker.buffers() end";
        options.desc = "Find buffers";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action.__raw = "function() Snacks.picker.help() end";
        options.desc = "Help tags";
      }
      {
        mode = "n";
        key = "<leader>fo";
        action.__raw = "function() Snacks.picker.recent() end";
        options.desc = "Recent files";
      }
      {
        mode = "n";
        key = "<leader>fw";
        action.__raw = "function() Snacks.picker.grep_word() end";
        options.desc = "Find word under cursor";
      }
      {
        mode = "n";
        key = "<leader>ft";
        action.__raw = "function() Snacks.picker.todo_comments() end";
        options.desc = "Find TODOs";
      }

      # ===== LSP =====
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<CR>";
        options.desc = "Go to definition";
      }
      {
        mode = "n";
        key = "gD";
        action = "<cmd>lua vim.lsp.buf.declaration()<CR>";
        options.desc = "Go to declaration";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>lua vim.lsp.buf.references()<CR>";
        options.desc = "Go to references";
      }
      {
        mode = "n";
        key = "gi";
        action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
        options.desc = "Go to implementation";
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        options.desc = "Hover documentation";
      }
      {
        mode = "n";
        key = "<leader>la";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options.desc = "Code action";
      }
      {
        mode = "n";
        key = "<leader>lr";
        action = "<cmd>lua vim.lsp.buf.rename()<CR>";
        options.desc = "Rename symbol";
      }
      {
        mode = "n";
        key = "<leader>lf";
        action = "<cmd>lua vim.lsp.buf.format()<CR>";
        options.desc = "Format buffer";
      }
      {
        mode = "n";
        key = "<leader>ld";
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Show diagnostics";
      }
      {
        mode = "n";
        key = "<leader>lS";
        action = "<cmd>AerialToggle<CR>";
        options.desc = "Symbols outline";
      }
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "Previous diagnostic";
      }
      {
        mode = "n";
        key = "]d";
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        options.desc = "Next diagnostic";
      }

      # ===== Terminal (snacks.terminal) =====
      {
        mode = ["n" "t"];
        key = "<C-\\>";
        action.__raw = "function() Snacks.terminal.toggle() end";
        options.desc = "Toggle terminal";
      }
      {
        mode = "n";
        key = "<leader>tf";
        action.__raw = "function() Snacks.terminal.toggle(nil, { win = { style = \"float\" } }) end";
        options.desc = "Float terminal";
      }
      {
        mode = "n";
        key = "<leader>th";
        action.__raw = "function() Snacks.terminal.toggle(nil, { win = { position = \"bottom\", height = 0.3 } }) end";
        options.desc = "Horizontal terminal";
      }
      {
        mode = "n";
        key = "<leader>tv";
        action.__raw = "function() Snacks.terminal.toggle(nil, { win = { position = \"right\", width = 0.4 } }) end";
        options.desc = "Vertical terminal";
      }
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
        options.desc = "Exit terminal mode";
      }
      {
        mode = "t";
        key = "jj";
        action = "<C-\\><C-n>";
        options.desc = "Exit terminal mode";
      }

      # ===== Git =====
      {
        mode = "n";
        key = "<leader>gg";
        action.__raw = "function() Snacks.lazygit() end";
        options.desc = "Lazygit";
      }
      {
        mode = "n";
        key = "<leader>gc";
        action.__raw = "function() Snacks.gitbrowse() end";
        options.desc = "Open file/commit in browser";
      }
      {
        mode = "n";
        key = "<leader>gp";
        action = "<cmd>GitBlameCopyPRURL<cr>";
        options.desc = "Copy PR URL";
      }
      # ===== Save/Quit =====
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<CR>";
        options.desc = "Save";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>q<CR>";
        options.desc = "Quit";
      }
      {
        mode = "n";
        key = "<leader>Q";
        action = "<cmd>qa!<CR>";
        options.desc = "Force quit all";
      }

      # ===== AutoSession ======
      # セッション検索・選択（Telescope使用）
      {
        mode = "n";
        key = "<leader>ss";
        action = "<cmd>AutoSession search<CR>";
        options = {
          desc = "Search sessions";
          silent = true;
        };
      }

      # セッション保存
      {
        mode = "n";
        key = "<leader>sw";
        action = "<cmd>AutoSession save<CR>";
        options = {
          desc = "Save session";
          silent = true;
        };
      }

      # セッション削除
      {
        mode = "n";
        key = "<leader>sd";
        action = "<cmd>AutoSession delete<CR>";
        options = {
          desc = "Delete session";
          silent = true;
        };
      }

      # 最後のセッションを復元
      {
        mode = "n";
        key = "<leader>sl";
        action = "<cmd>AutoSession restore_last<CR>";
        options = {
          desc = "Restore last session";
          silent = true;
        };
      }

      # 自動保存トグル
      {
        mode = "n";
        key = "<leader>st";
        action = "<cmd>AutoSession toggle<CR>";
        options = {
          desc = "Toggle autosave";
          silent = true;
        };
      }

      {
        mode = "n";
        key = "<leader>yr";
        action = "<cmd>CopyRelPath<CR>";
        options = {
          silent = true;
          desc = "Yank relative path";
        };
      }
      {
        mode = "n";
        key = "<leader>ya";
        action = "<cmd>CopyAbsPath<CR>";
        options = {
          silent = true;
          desc = "Yank absolute path";
        };
      }
      {
        mode = "n";
        key = "<leader>yf";
        action = "<cmd>CopyFileName<CR>";
        options = {
          silent = true;
          desc = "Yank file name";
        };
      }
      {
        mode = "n";
        key = "<leader>yy";
        action = "<cmd>%y+<CR>";
        options = {
          silent = true;
          desc = "Yank entire file to clipboard";
        };
      }
      {
        mode = "n";
        key = "<leader>yg";
        action = "<cmd>CopyGitHubLineURL<CR>";
        options = {
          silent = true;
          desc = "Yank GitHub line URL";
        };
      }
      {
        mode = "n";
        key = "<leader>yd";
        action = "<cmd>CopyDiagnostic<CR>";
        options = {
          silent = true;
          desc = "Yank diagnostic message";
        };
      }
      {
        mode = "n";
        key = "<leader>D";
        action = "<cmd>%d_<CR>";
        options = {
          silent = true;
          desc = "Delete all buffer content (no yank)";
        };
      }
      {
        mode = "n";
        key = "<leader>np";
        action = "<cmd>PasteNewBuffer<CR>";
        options = {
          silent = true;
          desc = "New buffer from clipboard";
        };
      }
      # ===== Claude (claudecode.nvim) =====
      {
        mode = "n";
        key = "<leader>at";
        action = "<cmd>ClaudeCode<CR>";
        options = {
          desc = "Toggle Claude Code";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>af";
        action = "<cmd>ClaudeCodeFocus<CR>";
        options = {
          desc = "Focus Claude Code";
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<leader>as";
        action = "<cmd>ClaudeCodeSend<CR>";
        options = {
          desc = "Send selection to Claude";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>ad";
        action = "<cmd>ClaudeCodeDiffAccept<CR>";
        options = {
          desc = "Accept Claude diff";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>aD";
        action = "<cmd>ClaudeCodeDiffDeny<CR>";
        options = {
          desc = "Deny Claude diff";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<M-Tab>";
        action.__raw = ''
          function()
            local current = vim.api.nvim_get_current_buf()
            local buffers = vim.api.nvim_list_bufs()

            -- 通常バッファだけをフィルタリング
            local normal_bufs = {}
            for _, buf in ipairs(buffers) do
              if vim.api.nvim_buf_is_valid(buf)
                 and vim.bo[buf].buflisted
                 and vim.bo[buf].buftype == "" -- 特殊バッファを除外
                 and vim.api.nvim_buf_get_name(buf) ~= "" then
                table.insert(normal_bufs, buf)
              end
            end

            -- 現在のバッファの次を探す
            for i, buf in ipairs(normal_bufs) do
              if buf == current then
                local next_buf = normal_bufs[i + 1] or normal_bufs[1]
                vim.api.nvim_set_current_buf(next_buf)
                return
              end
            end

            -- 見つからなかったら最初のバッファへ
            if #normal_bufs > 0 then
              vim.api.nvim_set_current_buf(normal_bufs[1])
            end
          end
        '';
        options = {
          desc = "次の通常バッファに移動";
          silent = true;
        };
      }

      {
        mode = "n";
        key = "<M-S-Tab>";
        action.__raw = ''
          function()
            local current = vim.api.nvim_get_current_buf()
            local buffers = vim.api.nvim_list_bufs()

            -- 通常バッファだけをフィルタリング
            local normal_bufs = {}
            for _, buf in ipairs(buffers) do
              if vim.api.nvim_buf_is_valid(buf)
                 and vim.bo[buf].buflisted
                 and vim.bo[buf].buftype == "" -- 特殊バッファを除外
                 and vim.api.nvim_buf_get_name(buf) ~= "" then
                table.insert(normal_bufs, buf)
              end
            end

            -- 現在のバッファの前を探す
            for i, buf in ipairs(normal_bufs) do
              if buf == current then
                local prev_buf = normal_bufs[i - 1] or normal_bufs[#normal_bufs]
                vim.api.nvim_set_current_buf(prev_buf)
                return
              end
            end

            -- 見つからなかったら最後のバッファへ
            if #normal_bufs > 0 then
              vim.api.nvim_set_current_buf(normal_bufs[#normal_bufs])
            end
          end
        '';
        options = {
          desc = "前の通常バッファに移動";
          silent = true;
        };
      }
    ];

    # ========================================
    # Extra Config (Lua)
    # ========================================
    extraConfigLua = ''
      -- Snacks setup
      -- snacks.nvim に移行したプラグイン:
      --   alpha        → snacks.dashboard
      --   neo-tree     → snacks.explorer
      --   telescope    → snacks.picker
      --   toggleterm   → snacks.terminal + snacks.lazygit
      --   indent-blankline → snacks.indent
      --   vim-bbye     → snacks.bufdelete
      require("snacks").setup({
        -- Picker (telescope の代替)
        picker = { enabled = true },

        -- Dashboard (alpha の代替)
        dashboard = {
          enabled = true,
          preset = {
            header = [[
         _            _          _     _          _
        /\ \     _   /\ \      / /\  /_/\        / /\
       /  \ \   /\_\/  \ \    / /  \ \_\ \      / /  \
      / /\ \ \_/ / / /\ \ \  / / /\ \/\_\/     / / /\ \__
     / / /\ \___/ / / /\ \_\/ / /\ \ \/_/     / / /\ \___\
    / / /  \/____/ /_/_ \/_/_/ /  \ \ \       \ \ \ \/___/
   / / /    / / / /____/\  \ \ \   \ \ \       \ \ \
  / / /    / / / /\____\/   \ \ \   \ \ \  _    \ \ \
 / / /    / / / / /______    \ \ \___\ \ \/_/\__/ / /
/ / /    / / / / /_______\    \ \/____\ \ \ \/___/ /
\/_/     \/_/\/__________/     \_________\/\_____\/ _
        /\ \     _ /\ \    _ / /\     /\ \     /\_\/\_\ _
       /  \ \   /\_\ \ \  /_/ / /     \ \ \   / / / / //\_\
      / /\ \ \_/ / /\ \ \ \___\/      /\ \_\ /\ \/ \ \/ / /
     / / /\ \___/ / / / /  \ \ \     / /\/_//  \____\__/ /
    / / /  \/____/  \ \ \   \_\ \   / / /  / /\/________/
   / / /    / / /    \ \ \  / / /  / / /  / / /\/_// / /
  / / /    / / /      \ \ \/ / /  / / /  / / /    / / /
 / / /    / / /        \ \ \/ /__/ / /__/ / /    / / /
/ / /    / / /          \ \  /\__\/_/___\/_/    / / /
\/_/     \/_/            \_\/\/__________/       \/_/       ]],
            keys = {
              { icon = " ", key = "f", desc = "Find File",    action = function() Snacks.picker.files() end },
              { icon = " ", key = "n", desc = "New File",     action = ":ene | startinsert" },
              { icon = " ", key = "r", desc = "Recent Files", action = function() Snacks.picker.recent() end },
              { icon = " ", key = "q", desc = "Quit",         action = ":qa" },
            },
          },
          sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
          },
        },

        -- Explorer (neo-tree の代替)
        explorer = { enabled = true },

        -- Indent (indent-blankline の代替)
        indent = {
          enabled = true,
          indent = {
            hl = {
              "RainbowRed", "RainbowYellow", "RainbowBlue",
              "RainbowOrange", "RainbowGreen", "RainbowViolet", "RainbowCyan",
            },
          },
        },

        -- Terminal (toggleterm の代替)
        terminal = {
          enabled = true,
          win = {
            style = "float",
            border = "curved",
          },
        },

        -- Lazygit (toggleterm lazygit の代替)
        lazygit = { enabled = true },

        -- Bufdelete (vim-bbye の代替)
        bufdelete = { enabled = true },

        -- Git browse
        gitbrowse = { enabled = true },

        -- Input UI 強化
        input = { enabled = true },

        -- その他便利機能
        bigfile    = { enabled = true },
        quickfile  = { enabled = true },
        statuscolumn = { enabled = true },
        words      = { enabled = true },
      })

      -- TermOpen: lazygit 以外のターミナルで direnv reload を実行
      vim.api.nvim_create_autocmd("TermOpen", {
        callback = function(ev)
          local name = vim.api.nvim_buf_get_name(ev.buf)
          if name:match("lazygit") then return end
          local chan = vim.b[ev.buf].terminal_job_id
          if chan and chan > 0 then
            vim.defer_fn(function()
              pcall(vim.fn.chansend, chan, "direnv reload\n")
            end, 500)
          end
        end,
      })

      -- OneDarkPro setup
      require("onedarkpro").setup({
        options = {
          transparency = false,
          terminal_colors = true,
          cursorline = true,
        }
      })

      -- Which-key labels
      local wk = require("which-key")
      wk.add({
        { "<leader>b", group = "Buffer" },
        { "<leader>f", group = "Find" },
        { "<leader>l", group = "LSP" },
        { "<leader>t", group = "Terminal" },
        { "<leader>s", group = "Session" },
        { "<leader>y", group = "Yank" },
        { "<leader>g", group = "Git" },
        { "<leader>a", group = "AI/Claude" },
        { "<leader>n", group = "New" },
        { "<leader>m", group = "Minimap" },
      })

      require('auto-session').setup({
        auto_save = true,        -- 自動保存
        auto_restore = true,     -- 自動復元
        auto_create = true,      -- 自動作成

        suppressed_dirs = {
          "~/",
          "~/Downloads",
          "~/Documents",
          "/tmp",
        },

        close_unsupported_windows = true,

        bypass_save_filetypes = {
          "snacks_dashboard",
        },

        auto_delete_empty_sessions = true,

        git_use_branch_name = true,

        session_lens = {
          load_on_setup = true,
          previewer = true,
        },
      })
      -- ヤンク時に自動でハイライト
      vim.api.nvim_create_autocmd('TextYankPost', {
        group = vim.api.nvim_create_augroup('highlight_yank', {}),
        pattern = '*',
        callback = function()
          vim.highlight.on_yank({
            higroup = 'IncSearch',  -- ハイライトグループ
            timeout = 100,          -- 表示時間（ミリ秒）
          })
        end,
      })

      -- :bdをsnacks.bufdeleteに上書き
      vim.api.nvim_create_user_command('Bd', function() Snacks.bufdelete() end, { force = true })
      vim.cmd('cnoreabbrev bd lua Snacks.bufdelete()')
      vim.cmd('cnoreabbrev bdelete lua Snacks.bufdelete()')

      -- 相対パスをクリップボードにコピー
      vim.api.nvim_create_user_command('CopyRelPath', function()
        local path = vim.fn.expand('%')
        vim.fn.setreg('+', path)
        vim.notify('Copied: ' .. path, vim.log.levels.INFO)
      end, {})

      -- 絶対パスもついでに！
      vim.api.nvim_create_user_command('CopyAbsPath', function()
        local path = vim.fn.expand('%:p')
        vim.fn.setreg('+', path)
        vim.notify('Copied: ' .. path, vim.log.levels.INFO)
      end, {})

      -- ファイル名だけコピーしたいときもあるよね
      vim.api.nvim_create_user_command('CopyFileName', function()
        local path = vim.fn.expand('%:t')
        vim.fn.setreg('+', path)
        vim.notify('Copied: ' .. path, vim.log.levels.INFO)
      end, {})

      vim.api.nvim_create_user_command('PasteNewBuffer', function()
        -- クリップボードの内容を取得
        local content = vim.fn.getreg('+')
        -- 新規バッファ作成
        vim.cmd('enew')

        -- クリップボードの内容を貼り付け
        vim.api.nvim_put(vim.split(content, '\n'), 'l', true, true)

        vim.notify('Created new buffer from clipboard', vim.log.levels.INFO)
      end, {})
      -- バッファ比較
      vim.api.nvim_create_user_command('DiffBuffers', function()
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
      end, {})

      vim.api.nvim_create_user_command('DiffOff', function()
        vim.cmd('diffoff!')
      end, {})

      -- 現在行のGitHub URLをクリップボードにコピー
      vim.api.nvim_create_user_command('CopyGitHubLineURL', function()
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
      end, {})

      -- フォーカス行の診断メッセージをクリップボードにコピー
      vim.api.nvim_create_user_command('CopyDiagnostic', function()
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
      end, {})
    '';

    # Rainbow highlight colors - snacks.indent用
    extraConfigLuaPre = ''
      -- nvim-treesitter と Neovim 0.11.x のバージョン不一致対応
      -- nvim-treesitter (新) が Neovim 本体に委譲した述語を手動登録する
      vim.treesitter.query.add_predicate("is-not?", function()
        return true
      end, { force = true })
      vim.treesitter.query.add_predicate("is?", function()
        return true
      end, { force = true })

      vim.opt.shortmess:append("I")
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    '';

    # ========================================
    # Extra Plugins
    # ========================================
    extraPlugins = with pkgs.vimPlugins; [
      onedarkpro-nvim  # カラースキーム
      snacks-nvim      # dashboard/picker/terminal/explorer/indent/lazygit/bufdelete
      (pkgs.vimUtils.buildVimPlugin {  # ミニマップ
        name = "neominimap.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "Isrothy";
          repo = "neominimap.nvim";
          rev = "v3.15.5";
          sha256 = "sha256-zfrBBM80hDZyrrVxBlSRar/XpaQOJE+SQHNyBEuGynA=";
        };
        doCheck = false;
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "claudecode.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "coder";
          repo = "claudecode.nvim";
          rev = "v0.3.0";
          sha256 = "sha256-sOBY2y/buInf+SxLwz6uYlUouDULwebY/nmDlbFbGa8=";
        };
        doCheck = false;
      })
    ];

    # Post setup
    extraConfigLuaPost = ''
      -- claudecode.nvim setup
      require("claudecode").setup()

      -- neominimap.nvim setup (v3以降は vim.g.neominimap で設定)
      vim.g.neominimap = { auto_enable = true }

      -- キーマップ (codewindow と同様の <leader>m プレフィックス)
      vim.keymap.set("n", "<leader>mm", "<cmd>Neominimap Toggle<cr>", { desc = "Toggle minimap" })
      vim.keymap.set("n", "<leader>mo", "<cmd>Neominimap On<cr>",     { desc = "Open minimap" })
      vim.keymap.set("n", "<leader>mc", "<cmd>Neominimap Off<cr>",    { desc = "Close minimap" })
      vim.keymap.set("n", "<leader>mf", "<cmd>Neominimap Focus<cr>",  { desc = "Focus minimap" })
    '';
  };
}
