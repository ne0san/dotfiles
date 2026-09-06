{ ... }:

{
  keymaps = [
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
      key = "<leader>al";
      action.__raw = ''
        function()
          local file = vim.api.nvim_buf_get_name(0)
          local line = vim.api.nvim_win_get_cursor(0)[1]
          vim.cmd("ClaudeCodeFocus")
          vim.cmd("ClaudeCodeAdd " .. vim.fn.fnameescape(file) .. " " .. line .. " " .. line)
        end
      '';
      options = {
        desc = "Add current line to Claude context and focus";
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
  ];
}
