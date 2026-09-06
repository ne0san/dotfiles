{ ... }:

{
  plugins = {
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
          # LSPの処理状況(progress)通知を無効化。デフォルトでは右下に
          # ミニウィンドウとして表示され続け、特にfsautocompleteの
          # ワークスペース読み込み中などに頻繁に更新されて邪魔になるため。
          progress = {
            enabled = false;
          };
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

    modicator = {
      enable = true;
    };
  };
}
