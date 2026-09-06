{ ... }:

{
  keymaps = [
    {
      mode = "n";
      key = "<leader>gg";
      action.__raw = "function() Snacks.lazygit() end";
      options.desc = "Lazygit";
    }
    {
      mode = "n";
      key = "<leader>jj";
      action.__raw = ''function() Snacks.terminal.toggle("jjui", { win = { style = "float", backdrop = false, wo = { winblend = 15 } }, count = 5 }) end'';
      options.desc = "Jjui";
    }
    {
      mode = "n";
      key = "<leader>gc";
      action.__raw = "function() Snacks.gitbrowse() end";
      options.desc = "Open file/commit in browser";
    }
    {
      mode = "n";
      key = "<leader>gp";
      action = "<cmd>GitBlameCopyPRURL<cr>";
      options.desc = "Copy PR URL";
    }
  ];
}
