{ ... }:

{
  plugins.lsp = {
    enable = true;
    servers = {
      # Lua
      lua_ls = {
        enable = true;
        settings = {
          Lua = {
            diagnostics = {
              globals = [ "vim" ];
            };
            # インレイヒント(推論された型・引数名)を返すようにする
            hint = {
              enable = true;
              arrayIndex = "Disable";
            };
          };
        };
      };
      # Rust
      rust_analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
      };
      # TypeScript
      # ts_lsはインレイヒントがデフォルトで全て無効なので明示的に有効化する
      # (推論された変数の型・戻り値の型・引数名などを薄く表示する)
      ts_ls = {
        enable = true;
        settings =
          let
            inlayHints = {
              includeInlayParameterNameHints = "literals";
              includeInlayParameterNameHintsWhenArgumentMatchesName = false;
              includeInlayVariableTypeHints = true;
              includeInlayVariableTypeHintsWhenTypeMatchesName = false;
              includeInlayFunctionParameterTypeHints = true;
              includeInlayFunctionLikeReturnTypeHints = true;
              includeInlayPropertyDeclarationTypeHints = true;
              includeInlayEnumMemberValueHints = true;
            };
          in
          {
            typescript = { inherit inlayHints; };
            javascript = { inherit inlayHints; };
          };
      };
      # Nix
      nil_ls = {
        enable = true;
      };
      # go
      # goplsもインレイヒントはデフォルト無効なので有効化する
      gopls = {
        enable = true;
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true;
              compositeLiteralFields = true;
              compositeLiteralTypes = true;
              constantValues = true;
              functionTypeParameters = true;
              parameterNames = true;
              rangeVariableTypes = true;
            };
          };
        };
      };
      jsonls = {
        enable = true;
      };
      fsautocomplete = {
        enable = true;
        settings = {
          FSharp = {
            InlayHints = {
              enabled = true;
              typeAnnotations = true;
              parameterNames = true;
            };
            UnusedDeclarationsAnalyzer = true;
          };
        };
      };
      elixirls = {
        enable = true;
      };
    };
  };
}
