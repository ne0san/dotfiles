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
          "neo-tree"
          "NvimTree"
          "TelescopePrompt"
          "qf"
          "help"
          "aerial"
          "alpha"
        ];
        callback = {
          __raw = ''
            function()
              vim.opt_local.buflisted = false
            end
          '';
        };
      }
    ];
    opts = {
      # 行番号
      number = true;
      relativenumber = true;

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
      foldlevel = 99;        # 最初は全部開いた状態
      foldlevelstart = 99;   # ファイル開いた時も全部開く
    };

    # ========================================
    # Colorscheme (extraPluginsで設定 - モジュールにバグがあるため)
    # ========================================
    colorscheme = "onedark_vivid";  # onedarkpro.nvimのvividテーマ

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
          max_lines = 3;  # 表示する最大行数
          min_window_height = 0;
          mode = "cursor";  # or "topline"
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

      # Neo-tree (ファイルツリー)
      neo-tree = {
        enable = true;
        settings = {
          filesystem = {
            follow_current_file = {
              enabled = true;
            };
            hijack_netrw_behavior = "open_current";
            use_libuv_file_watcher = true;
            filtered_items = {
              visible = false;
              show_hidden_count = true;
              hide_dotfiles = false;
              hide_gitignored = false;
              hide_by_name = [
                "node_modules"
                "thumbs.db"
              ];
              never_show = [
                ".git"
                ".DS_Store"
                ".history"
              ];
            };
          };
        };
      };

      # Alpha (ダッシュボード)
      alpha = {
        enable = true;
        settings = {
          layout = [
            {
              type = "padding";
              val = 2;
            }
            {
              type = "text";
              val = [
                "         _            _          _     _          _        "
                "        /\\ \\     _   /\\ \\      / /\\  /_/\\        / /\\      "
                "       /  \\ \\   /\\_\\/  \\ \\    / /  \\ \\_\\ \\      / /  \\     "
                "      / /\\ \\ \\_/ / / /\\ \\ \\  / / /\\ \\/\\_\\/     / / /\\ \\__  "
                "     / / /\\ \\___/ / / /\\ \\_\\/ / /\\ \\ \\/_/     / / /\\ \\___\\ "
                "    / / /  \\/____/ /_/_ \\/_/_/ /  \\ \\ \\       \\ \\ \\ \\/___/ "
                "   / / /    / / / /____/\\  \\ \\ \\   \\ \\ \\       \\ \\ \\       "
                "  / / /    / / / /\\____\\/   \\ \\ \\   \\ \\ \\  _    \\ \\ \\      "
                " / / /    / / / / /______    \\ \\ \\___\\ \\ \\/_/\\__/ / /      "
                "/ / /    / / / / /_______\\    \\ \\/____\\ \\ \\ \\/___/ /       "
                "\\/_/     \\/_/\\/__________/     \\_________\\/\\_____\\/ _      "
                "        /\\ \\     _ /\\ \\    _ / /\\     /\\ \\     /\\_\\/\\_\\ _  "
                "       /  \\ \\   /\\_\\ \\ \\  /_/ / /     \\ \\ \\   / / / / //\\_\\"
                "      / /\\ \\ \\_/ / /\\ \\ \\ \\___\\/      /\\ \\_\\ /\\ \\/ \\ \\/ / /"
                "     / / /\\ \\___/ / / / /  \\ \\ \\     / /\\/_//  \\____\\__/ / "
                "    / / /  \\/____/  \\ \\ \\   \\_\\ \\   / / /  / /\\/________/  "
                "   / / /    / / /    \\ \\ \\  / / /  / / /  / / /\\/_// / /   "
                "  / / /    / / /      \\ \\ \\/ / /  / / /  / / /    / / /    "
                " / / /    / / /        \\ \\ \\/ /__/ / /__/ / /    / / /     "
                "/ / /    / / /          \\ \\  /\\__\\/_/___\\/_/    / / /      "
                "\\/_/     \\/_/            \\_\\/\\/_________/       \\/_/       "
              ];
              opts = {
                position = "center";
                hl = "Type";
              };
            }
            {
              type = "padding";
              val = 2;
            }
            {
              type = "group";
              val = [
                {
                  type = "button";
                  val = "  Find File";
                  on_press.__raw = "function() require('telescope.builtin').find_files() end";
                  opts = {
                    keymap = ["n" "f" ":Telescope find_files<CR>" { silent = true; noremap = true; }];
                    shortcut = "f";
                    position = "center";
                    cursor = 3;
                    width = 50;
                    align_shortcut = "right";
                    hl_shortcut = "Keyword";
                  };
                }
                {
                  type = "button";
                  val = "  New File";
                  on_press.__raw = "function() vim.cmd('ene') end";
                  opts = {
                    keymap = ["n" "n" ":ene<CR>" { silent = true; noremap = true; }];
                    shortcut = "n";
                    position = "center";
                    cursor = 3;
                    width = 50;
                    align_shortcut = "right";
                    hl_shortcut = "Keyword";
                  };
                }
                {
                  type = "button";
                  val = "  Recent Files";
                  on_press.__raw = "function() require('telescope.builtin').oldfiles() end";
                  opts = {
                    keymap = ["n" "r" ":Telescope oldfiles<CR>" { silent = true; noremap = true; }];
                    shortcut = "r";
                    position = "center";
                    cursor = 3;
                    width = 50;
                    align_shortcut = "right";
                    hl_shortcut = "Keyword";
                  };
                }
                {
                  type = "button";
                  val = "  Quit";
                  on_press.__raw = "function() vim.cmd('qa') end";
                  opts = {
                    keymap = ["n" "q" ":qa<CR>" { silent = true; noremap = true; }];
                    shortcut = "q";
                    position = "center";
                    cursor = 3;
                    width = 50;
                    align_shortcut = "right";
                    hl_shortcut = "Keyword";
                  };
                }
              ];
            }
          ];
        };
      };

      # Telescope (ファジーファインダー)
      telescope = {
        enable = true;
      };

      # Which-key (キーバインドヘルプ)
      which-key = {
        enable = true;
      };

      # Lualine (ステータスライン)
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "onedark";  # onedarkproと互換性あり
            globalstatus = true;
          };
        };
      };

      # Bufferline (バッファタブ)
      bufferline = {
        enable = true;
      };

      # Indent-blankline
      indent-blankline = {
        enable = true;
        settings = {
          indent = {
            highlight = [
              "RainbowRed"
              "RainbowYellow"
              "RainbowBlue"
              "RainbowOrange"
              "RainbowGreen"
              "RainbowViolet"
              "RainbowCyan"
            ];
          };
        };
      };

      # Git signs
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;  # 現在行のblame表示
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "right_align";  # 行末に表示
            delay = 0;  # 表示までの遅延(ms)
          };
          current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>";
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
          backends = ["treesitter" "lsp"];
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
          ignored_filetypes = ["nofile" "quickfix" "prompt"];
          ignored_buftypes = ["NvimTree"];
        };
      };

      # ttiny-inline-diagnostic(インラインで診断メッセージ)
      tiny-inline-diagnostic = {
        enable = true;
        settings = {
          preset = "modern";  # "ghost", "classic", "modern"から選べる
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
            python = [ "isort" "black" ];
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
        key = "<leader>bd";
        action = "<cmd>bdelete<CR>";
        options.desc = "Delete buffer";
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
        key = "<S-Up>";
        action.__raw = "function() require('smart-splits').resize_up() end";
        options.desc = "Resize window up";
      }
      {
        mode = "n";
        key = "<S-Down>";
        action.__raw = "function() require('smart-splits').resize_down() end";
        options.desc = "Resize window down";
      }
      {
        mode = "n";
        key = "<S-Left>";
        action.__raw = "function() require('smart-splits').resize_left() end";
        options.desc = "Resize window left";
      }
      {
        mode = "n";
        key = "<S-Right>";
        action.__raw = "function() require('smart-splits').resize_right() end";
        options.desc = "Resize window right";
      }

      # ===== Neo-tree =====
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle file explorer";
      }
      {
        mode = "n";
        key = "<leader>o";
        action = "<cmd>Neotree focus<CR>";
        options.desc = "Focus file explorer";
      }

      # ===== Telescope =====
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Live grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<CR>";
        options.desc = "Find buffers";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Telescope help_tags<CR>";
        options.desc = "Help tags";
      }
      {
        mode = "n";
        key = "<leader>fo";
        action = "<cmd>Telescope oldfiles<CR>";
        options.desc = "Recent files";
      }
      {
        mode = "n";
        key = "<leader>fw";
        action = "<cmd>Telescope grep_string<CR>";
        options.desc = "Find word under cursor";
      }
      {
        mode = "n";
        key = "<leader>ft";
        action = "<cmd>TodoTelescope<CR>";
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

      # ===== Terminal =====
      {
        mode = "n";
        key = "<leader>tf";
        action = "<cmd>ToggleTerm direction=float<CR>";
        options.desc = "Float terminal";
      }
      {
        mode = "n";
        key = "<leader>th";
        action = "<cmd>ToggleTerm direction=horizontal<CR>";
        options.desc = "Horizontal terminal";
      }
      {
        mode = "n";
        key = "<leader>tv";
        action = "<cmd>ToggleTerm direction=vertical<CR>";
        options.desc = "Vertical terminal";
      }
      {
        mode = "t";
        key = "<Esc>";
        action = "<C-\\><C-n>";
        options.desc = "Exit terminal mode";
      }

      # ===== Git =====
      {
        mode = "n";
        key = "<leader>g";
        action = "<cmd>lua _lazygit_toggle()<CR>";
        options.desc = "Lazygit";
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
    ];

    # ========================================
    # Extra Config (Lua)
    # ========================================
    extraConfigLua = ''
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
      })
    '';

    # Rainbow highlight colors - ibl.setupより前に定義する必要あり
    extraConfigLuaPre = ''
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
      toggleterm-nvim
      onedarkpro-nvim  # カラースキーム
    ];

    # ToggleTerm setup
    extraConfigLuaPost = ''
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]],
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })

      -- Lazygit専用ターミナル (別インスタンスとして管理)
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        hidden = true,
        float_opts = {
          border = "curved",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _lazygit_toggle()
        lazygit:toggle()
      end
    '';
  };
}
