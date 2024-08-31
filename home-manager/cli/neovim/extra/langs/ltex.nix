{
  config,
  lib,
  ...
}: let
  enable = config.homeManagerConfig.nixvimConfig.type == "full";
  filetypes = ["latex" "tex" "plaintex" "markdown" "gitcommit" "org" "html" "typst"];
in {
  config = lib.mkIf enable {
    programs.nixvim.plugins.ltex-extra = {
      enable = true;
      settings = {
        load_langs = ["en-US" "zh-CN"];
        path = ".ltex";
      };
    };

    programs.nixvim.plugins.lsp.servers.ltex = {
      inherit filetypes;
      settings.ltex.enabled = filetypes;
    };
  };
}
