{pkgs, ...}: {
  programs.nixvim.plugins = {
    treesitter.grammarPackages = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.nix];
    lsp.servers.nixd = {
      enable = true;
      # disable formatting
      onAttach.function = ''
        client.server_capabilities.documentFormattingProvider = false
      '';
    };
    none-ls.sources = {
      formatting.alejandra.enable = true;
      diagnostics.deadnix.enable = true;
      diagnostics.statix.enable = true;
      code_actions.statix.enable = true;
    };
  };
}
