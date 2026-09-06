{ ... }:

{
  keymaps = [
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
      key = "<leader>yG";
      action = "<cmd>CopyGitHubMasterLineURL<CR>";
      options = {
        silent = true;
        desc = "Yank GitHub line URL (master)";
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
  ];
}
