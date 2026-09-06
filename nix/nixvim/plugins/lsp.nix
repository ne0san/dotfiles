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
      ts_ls = {
        enable = true;
      };
      # Nix
      nil_ls = {
        enable = true;
      };
      # go
      gopls = {
        enable = true;
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
