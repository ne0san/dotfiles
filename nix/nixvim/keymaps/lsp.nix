{ ... }:

{
  keymaps = [
    {
      mode = "n";
      key = "gd";
      action.__raw = "function() Snacks.picker.lsp_definitions({ auto_confirm = false }) end";
      options.desc = "Go to definition (choose action in popup)";
    }
    {
      mode = "n";
      key = "gD";
      action.__raw = "function() Snacks.picker.lsp_type_definitions({ auto_confirm = false }) end";
      options.desc = "Go to type definition (choose action in popup)";
    }
    {
      mode = "n";
      key = "gr";
      action.__raw = "function() Snacks.picker.lsp_references({ auto_confirm = false }) end";
      options.desc = "Go to references (choose action in popup)";
    }
    {
      mode = "n";
      key = "gi";
      action.__raw = "function() Snacks.picker.lsp_implementations({ auto_confirm = false }) end";
      options.desc = "Go to implementation (choose action in popup)";
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
      key = "<leader>li";
      action.__raw = ''
        function()
          local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
          vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
        end
      '';
      options.desc = "Toggle inlay hints";
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
  ];
}
