{ ... }:

{
  keymaps = [
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
  ];
}
