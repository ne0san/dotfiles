{ lib, ... }:

{
  plugins = {
    # Autopairs
    nvim-autopairs = {
      enable = true;
    };

    # Comment
    comment = {
      enable = true;
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
      settings = {
        auto_save = true; # 自動保存
        auto_restore = true; # 自動復元
        auto_create = true; # 自動作成

        suppressed_dirs = [
          "~/"
          "~/Downloads"
          "~/Documents"
          "/tmp"
        ];

        close_unsupported_windows = true;

        bypass_save_filetypes = [
          "snacks_dashboard"
        ];

        auto_delete_empty_sessions = true;

        # jj (Jujutsu) はコロケートリポジトリだと常にgitを detached HEAD にするため、
        # 素の `git rev-parse --abbrev-ref HEAD` は常に "HEAD" を返してしまい、
        # git管理下でつけたセッション名 (例: "main") と一致せず自動復元されなくなる。
        # jjリポジトリの場合は @ の祖先にある最も近いbookmarkを代わりに使う。
        git_use_branch_name = lib.nixvim.mkRaw ''
          function(path)
            local cwd = path or vim.fn.getcwd()

            if vim.fn.finddir(".jj", cwd .. ";") ~= "" then
              local out = vim.fn.system({
                "jj",
                "-R",
                cwd,
                "log",
                "--no-graph",
                "-r",
                "heads(::@ & bookmarks())",
                "-T",
                "bookmarks.join(\",\")",
              })
              if vim.v.shell_error ~= 0 then
                return nil
              end
              out = vim.trim(out)
              if out == "" then
                return nil
              end
              return vim.split(out, ",")[1]
            end

            local branch = vim.trim(vim.fn.system({ "git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD" }))
            if vim.v.shell_error ~= 0 or branch == "" or branch == "HEAD" then
              return nil
            end
            return branch
          end
        '';

        session_lens = {
          load_on_setup = true;
          previewer = true;
        };
      };
    };

    # ファイルごとにshiftwidth/expandtabを自動判別する
    sleuth = {
      enable = true;
    };
  };
}
