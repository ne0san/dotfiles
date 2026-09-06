{ ... }:

{
  # Snacks setup
  # snacks.nvim に移行したプラグイン:
  #   alpha        → snacks.dashboard
  #   neo-tree     → snacks.explorer
  #   telescope    → snacks.picker
  #   toggleterm   → snacks.terminal + snacks.lazygit
  #   indent-blankline → snacks.indent
  #   vim-bbye     → snacks.bufdelete
  plugins.snacks = {
    enable = true;
    settings = {
      # Picker (telescope の代替)
      picker = {
        enabled = true;
        sources = {
          # Explorer で隠しファイルもデフォルト表示する
          explorer = {
            hidden = true;
          };
        };
      };

      # Dashboard (alpha の代替)
      dashboard = {
        enabled = true;
        preset = {
          header = ''
              \  | ____|  _ \  ) ___|
               \ | __|   |   |/\___ \
             |\  | |     |   |       |
            _| \_|_____|\___/  _____/

              \  |\ \     /_ _|  \  |
               \ | \ \   /   |  |\/ |
             |\  |  \ \ /    |  |   |
            _| \_|   \_/   ___|_|  _| '';
          keys = [
            {
              icon = " ";
              key = "f";
              desc = "Find File";
              action.__raw = "function() Snacks.picker.files() end";
            }
            {
              icon = " ";
              key = "n";
              desc = "New File";
              action = ":ene | startinsert";
            }
            {
              icon = " ";
              key = "r";
              desc = "Recent Files";
              action.__raw = "function() Snacks.picker.recent() end";
            }
            {
              icon = " ";
              key = "s";
              desc = "Sessions";
              action = ":AutoSession search";
            }
            {
              icon = " ";
              key = "q";
              desc = "Quit";
              action = ":qa";
            }
          ];
        };
        sections = [
          { section = "header"; }
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
        ];
      };

      # Explorer (neo-tree の代替)
      explorer = {
        enabled = true;
      };

      # Indent (indent-blankline の代替)
      indent = {
        enabled = true;
        indent = {
          hl = [
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

      # Terminal (toggleterm の代替)
      terminal = {
        enabled = true;
        win = {
          style = "float";
          border = "rounded";
          # backdrop(全画面を覆う暗転オーバーレイ)は背後のウィンドウの文字を
          # 空白セルで上書きしてしまい、explorerペインが「何も表示されない」
          # 状態に見える原因になるため無効化する。
          # 代わりにwinblendでフロート自体を擬似的に半透明化する。
          backdrop = false;
          wo.winblend = 15;
        };
      };

      # Lazygit (toggleterm lazygit の代替)
      lazygit = {
        enabled = true;
        win = {
          backdrop = false;
          wo.winblend = 15;
        };
      };

      # Bufdelete (vim-bbye の代替)
      bufdelete = {
        enabled = true;
      };

      # Git browse
      gitbrowse = {
        enabled = true;
      };

      # Input UI 強化
      input = {
        enabled = true;
      };

      # その他便利機能
      bigfile = {
        enabled = true;
      };
      quickfile = {
        enabled = true;
      };
      statuscolumn = {
        enabled = true;
      };
      words = {
        enabled = true;
      };
    };
  };
}
