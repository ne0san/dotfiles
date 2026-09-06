{ pkgs, ... }:

{
  extraPlugins = with pkgs.vimPlugins; [
    onedarkpro-nvim  # カラースキーム (colorschemes.onedarkproはモジュール未提供のため手動導入)
    # F#のオフサイドルールに対応したインデント(indent/fsharp.vim)目的で導入。
    # LSPバックエンドはg:fsharp#backendで無効化済み(fsautocompleteはnixvim側で設定)
    Ionide-vim
    (pkgs.vimUtils.buildVimPlugin {  # ミニマップ
      name = "neominimap.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "Isrothy";
        repo = "neominimap.nvim";
        rev = "v3.15.5";
        sha256 = "sha256-zfrBBM80hDZyrrVxBlSRar/XpaQOJE+SQHNyBEuGynA=";
      };
      doCheck = false;
    })
    (pkgs.vimUtils.buildVimPlugin {
      name = "claudecode.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "coder";
        repo = "claudecode.nvim";
        rev = "v0.3.0";
        sha256 = "sha256-sOBY2y/buInf+SxLwz6uYlUouDULwebY/nmDlbFbGa8=";
      };
      doCheck = false;
    })
  ];
}
