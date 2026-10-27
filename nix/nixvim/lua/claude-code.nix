{ ... }:

{
  extraConfigLuaPost = ''
    -- claudecode.nvim setup
    -- claudecode.nvim はシェルを経由せず claude バイナリを直接起動するため、
    -- direnv のシェルフックが発火せず devenv の環境変数が反映されない。
    -- direnv exec でラップして、シェル非依存で devenv の環境変数を読み込む。
    require("claudecode").setup({
      terminal_cmd = "direnv exec . claude",
    })

    -- 編集プレビュー(diff)を既存のエディタペインで開く。
    -- 標準では対象ペインに別ファイルが表示されていると、元ファイル用と提案用で
    -- 2回分割してペインが増える。事前に対象ペインへ元ファイル(新規ファイルなら空バッファ)を
    -- 表示しておくと、プラグインがそのペインを再利用するため増えるのは提案側の1枚だけになる。
    -- diff終了時には元々表示していたバッファへ戻す。
    do
      local diff = require("claudecode.diff")
      local orig_create = diff._create_diff_view_from_window
      local orig_cleanup = diff._cleanup_diff_state
      local restore = {}

      diff._create_diff_view_from_window = function(target_win, old_path, new_buf, tab_name, is_new_file, term_win_in_new_tab, existing_buf)
        if target_win and vim.api.nvim_win_is_valid(target_win) and not term_win_in_new_tab then
          local prev_buf = vim.api.nvim_win_get_buf(target_win)
          if vim.api.nvim_buf_get_name(prev_buf) ~= old_path then
            restore[tab_name] = { win = target_win, buf = prev_buf }
            if is_new_file then
              local scratch = vim.api.nvim_create_buf(false, true)
              vim.bo[scratch].bufhidden = "wipe"
              vim.api.nvim_win_set_buf(target_win, scratch)
            elseif existing_buf and vim.api.nvim_buf_is_valid(existing_buf) then
              vim.api.nvim_win_set_buf(target_win, existing_buf)
            else
              vim.api.nvim_win_call(target_win, function()
                vim.cmd("edit " .. vim.fn.fnameescape(old_path))
              end)
            end
          end
        end
        return orig_create(target_win, old_path, new_buf, tab_name, is_new_file, term_win_in_new_tab, existing_buf)
      end

      diff._cleanup_diff_state = function(tab_name, reason)
        orig_cleanup(tab_name, reason)
        local r = restore[tab_name]
        restore[tab_name] = nil
        if r and vim.api.nvim_win_is_valid(r.win) and vim.api.nvim_buf_is_valid(r.buf) then
          vim.api.nvim_win_set_buf(r.win, r.buf)
        end
      end
    end
  '';
}
