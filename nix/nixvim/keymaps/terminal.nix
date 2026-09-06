{ ... }:

{
  keymaps = [
    {
      mode = [
        "n"
        "t"
      ];
      key = "<C-\\>";
      action.__raw = ''function() Snacks.terminal.toggle("fish", { count = 1 }) end'';
      options.desc = "Toggle terminal";
    }
    {
      mode = "n";
      key = "<leader>tf";
      action.__raw = ''function() Snacks.terminal.toggle("fish", { win = { style = "float" }, count = 2 }) end'';
      options.desc = "Float terminal";
    }
    {
      mode = "n";
      key = "<leader>th";
      action.__raw = ''function() Snacks.terminal.toggle("fish", { win = { position = "bottom", height = 0.3 }, count = 3 }) end'';
      options.desc = "Horizontal terminal";
    }
    {
      mode = "n";
      key = "<leader>tv";
      action.__raw = ''function() Snacks.terminal.toggle("fish", { win = { position = "right", width = 0.4 }, count = 4 }) end'';
      options.desc = "Vertical terminal";
    }
    {
      mode = "t";
      key = "<Esc><Esc>";
      action = "<C-\\><C-n>";
      options.desc = "Exit terminal mode";
    }
    {
      mode = "t";
      key = "tt";
      action = "<C-\\><C-n>";
      options.desc = "Exit terminal mode";
    }
  ];
}
