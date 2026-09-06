{ ... }:

{
  plugins = {
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
        highlight_group = "GitBlame";
      };
    };
  };

  autoCmd = [
    {
      # gitblame と tiny-inline-diagnostic がどちらも行末に表示するため、
      # カーソル行に診断がある間は gitblame を無効化して重なりを防ぐ
      # (gitblame に enabled のバッファローカル設定は存在しないため M.enable/M.disable を使う)
      event = [
        "CursorMoved"
        "CursorMovedI"
        "DiagnosticChanged"
      ];
      callback.__raw = ''
        function()
          local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
          local has_diagnostic = #vim.diagnostic.get(0, { lnum = lnum }) > 0
          local gitblame = require("gitblame")
          if has_diagnostic then
            gitblame.disable()
          else
            gitblame.enable()
          end
        end
      '';
      desc = "gitblameとtiny-inline-diagnosticの行末表示の重なりを防ぐ";
    }
  ];
}
