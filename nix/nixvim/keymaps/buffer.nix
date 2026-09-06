{ ... }:

{
  keymaps = [
    # ===== バッファ操作 =====
    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<CR>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "[b";
      action = "<cmd>bprevious<CR>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "<leader>bn";
      action = "<cmd>bnext<CR>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>bprevious<CR>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "<leader>bf";
      action.__raw = "function() Snacks.picker.buffers() end";
      options.desc = "Find buffers";
    }
    {
      mode = "n";
      key = "<leader>bD";
      action.__raw = "function() Snacks.bufdelete(0, { force = true }) end";
      options = {
        silent = true;
        desc = "Force delete buffer keep window";
      };
    }
    {
      mode = "n";
      key = "<leader>bd";
      action.__raw = "function() Snacks.bufdelete() end";
      options = {
        silent = true;
        desc = "Delete buffer keep window";
      };
    }
    {
      mode = "n";
      key = "<leader>bz";
      action = "<cmd>DeleteHiddenBuffers<CR>";
      options = {
        silent = true;
        desc = "Delete buffers not shown in any window";
      };
    }
    {
      mode = "n";
      key = "<leader>bc";
      action = "<cmd>DiffBuffers<CR>";
      options = {
        silent = true;
        desc = "Compare with another buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>bo";
      action = "<cmd>DiffOff<CR>";
      options = {
        silent = true;
        desc = "Turn off diff mode";
      };
    }
    # 差分間の移動
    {
      mode = "n";
      key = "]c";
      action = "]c";
      options = {
        desc = "Next diff";
      };
    }
    {
      mode = "n";
      key = "[c";
      action = "[c";
      options = {
        desc = "Previous diff";
      };
    }
    # 次の通常バッファに移動 (M-Tab)
    {
      mode = "n";
      key = "<M-Tab>";
      action.__raw = ''
        function()
          local current = vim.api.nvim_get_current_buf()
          local buffers = vim.api.nvim_list_bufs()

          -- 通常バッファだけをフィルタリング
          local normal_bufs = {}
          for _, buf in ipairs(buffers) do
            if vim.api.nvim_buf_is_valid(buf)
               and vim.bo[buf].buflisted
               and vim.bo[buf].buftype == "" -- 特殊バッファを除外
               and vim.api.nvim_buf_get_name(buf) ~= "" then
              table.insert(normal_bufs, buf)
            end
          end

          -- 現在のバッファの次を探す
          for i, buf in ipairs(normal_bufs) do
            if buf == current then
              local next_buf = normal_bufs[i + 1] or normal_bufs[1]
              vim.api.nvim_set_current_buf(next_buf)
              return
            end
          end

          -- 見つからなかったら最初のバッファへ
          if #normal_bufs > 0 then
            vim.api.nvim_set_current_buf(normal_bufs[1])
          end
        end
      '';
      options = {
        desc = "次の通常バッファに移動";
        silent = true;
      };
    }
    # 前の通常バッファに移動 (M-S-Tab)
    {
      mode = "n";
      key = "<M-S-Tab>";
      action.__raw = ''
        function()
          local current = vim.api.nvim_get_current_buf()
          local buffers = vim.api.nvim_list_bufs()

          -- 通常バッファだけをフィルタリング
          local normal_bufs = {}
          for _, buf in ipairs(buffers) do
            if vim.api.nvim_buf_is_valid(buf)
               and vim.bo[buf].buflisted
               and vim.bo[buf].buftype == "" -- 特殊バッファを除外
               and vim.api.nvim_buf_get_name(buf) ~= "" then
              table.insert(normal_bufs, buf)
            end
          end

          -- 現在のバッファの前を探す
          for i, buf in ipairs(normal_bufs) do
            if buf == current then
              local prev_buf = normal_bufs[i - 1] or normal_bufs[#normal_bufs]
              vim.api.nvim_set_current_buf(prev_buf)
              return
            end
          end

          -- 見つからなかったら最後のバッファへ
          if #normal_bufs > 0 then
            vim.api.nvim_set_current_buf(normal_bufs[#normal_bufs])
          end
        end
      '';
      options = {
        desc = "前の通常バッファに移動";
        silent = true;
      };
    }
  ];
}
