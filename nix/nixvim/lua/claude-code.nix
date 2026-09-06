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
  '';
}
