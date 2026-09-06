{ ... }:

{
  keymaps = [
    # ===== Explorer (snacks.explorer) =====
    {
      mode = "n";
      key = "<leader>e";
      action.__raw = "function() Snacks.explorer() end";
      options.desc = "Toggle file explorer";
    }
    {
      mode = "n";
      key = "<leader>o";
      action.__raw = "function() Snacks.explorer() end";
      options.desc = "Focus file explorer";
    }

    # ===== Finder (snacks.picker) =====
    {
      mode = "n";
      key = "<leader>ff";
      action.__raw = "function() Snacks.picker.files() end";
      options.desc = "Find files";
    }
    {
      mode = "n";
      key = "<leader>fg";
      action.__raw = "function() Snacks.picker.grep() end";
      options.desc = "Live grep";
    }
    {
      mode = "n";
      key = "<leader>fb";
      action.__raw = "function() Snacks.picker.buffers() end";
      options.desc = "Find buffers";
    }
    {
      mode = "n";
      key = "<leader>fh";
      action.__raw = "function() Snacks.picker.help() end";
      options.desc = "Help tags";
    }
    {
      mode = "n";
      key = "<leader>fo";
      action.__raw = "function() Snacks.picker.recent() end";
      options.desc = "Recent files";
    }
    {
      mode = "n";
      key = "<leader>fw";
      action.__raw = "function() Snacks.picker.grep_word() end";
      options.desc = "Find word under cursor";
    }
    {
      mode = "n";
      key = "<leader>ft";
      action.__raw = "function() Snacks.picker.todo_comments() end";
      options.desc = "Find TODOs";
    }
  ];
}
