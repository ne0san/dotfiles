{ pkgs, ... }:

{
  plugins = {
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      # Lua, Rust, TypeScript + 基本的な言語
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        lua
        rust
        typescript
        tsx
        javascript
        json
        html
        css
        nix
        markdown
        markdown_inline
        vim
        vimdoc
        bash
        yaml
        toml
        go
        elixir
        fsharp
      ];
    };

    treesitter-context = {
      enable = true;
      # アップストリームはカーソルとウィンドウ最上行との距離でヘッダの高さを
      # 強制的に縮める実装になっており、設定では無効化できない(calc_max_lines内)。
      # ヘッダがカーソル接近時に省略されるのを防ぐため、ウィンドウ高さ基準に
      # 差し替えるパッチを当てる。
      package = pkgs.vimPlugins.nvim-treesitter-context.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace lua/treesitter-context/context.lua \
            --replace-fail \
              "local max_from_cursor = cursor - wintop" \
              "local max_from_cursor = api.nvim_win_get_height(winid)"
        '';
      });
      settings = {
        max_lines = 0; # 表示する最大行数の制限をなくす
        min_window_height = 0;
        mode = "topline"; # ウィンドウ最上行基準で絶対的に表示する(カーソル位置に依存しない)
        multiwindow = true; # フォーカスしていないウィンドウでもヘッダ追従を表示する
        trim_scope = "outer";
        zindex = 30;
      };
    };
  };
}
