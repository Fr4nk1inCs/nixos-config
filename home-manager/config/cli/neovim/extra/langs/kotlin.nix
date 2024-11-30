{
  config,
  lib,
  pkgs,
  ...
}: let
  enable = config.homeManagerConfig.nixvimConfig.type == "full";
in {
  config = lib.mkIf enable {
    programs.nixvim.plugins = {
      treesitter.grammarPackages = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.kotlin];
      lsp.servers.kotlin_language_server.enable = true;
      none-ls.sources.formatting.ktlint.enable = true;
      none-ls.sources.diagnostics.ktlint.enable = true;
    };
  };
}
