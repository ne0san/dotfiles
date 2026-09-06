{ ... }:

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

        git_use_branch_name = true;

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
