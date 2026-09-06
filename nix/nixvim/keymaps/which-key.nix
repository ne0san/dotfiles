{ ... }:

{
  plugins.which-key = {
    enable = true;

    settings = {
      delay = 0;
      win = {
        border = "rounded";
      };

      spec = [
        {
          __unkeyed-1 = "<leader>b";
          group = "Buffer";
        }
        {
          __unkeyed-1 = "<leader><Tab>";
          group = "Tab";
        }
        {
          __unkeyed-1 = "<leader>f";
          group = "Find";
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "LSP";
        }
        {
          __unkeyed-1 = "<leader>t";
          group = "Terminal";
        }
        {
          __unkeyed-1 = "<leader>s";
          group = "Session";
        }
        {
          __unkeyed-1 = "<leader>y";
          group = "Yank";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "Git";
        }
        {
          __unkeyed-1 = "<leader>j";
          group = "Jujutsu";
        }
        {
          __unkeyed-1 = "<leader>a";
          group = "AI/Claude";
        }
        {
          __unkeyed-1 = "<leader>n";
          group = "New";
        }
        {
          __unkeyed-1 = "<leader>m";
          group = "Minimap";
        }
        {
          __unkeyed-1 = "<leader>u";
          group = "UI";
        }
      ];
    };
  };
}
