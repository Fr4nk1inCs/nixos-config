_: {
  programs.nixvim.plugins = {
    treesitter.settings.ensure_installed = ["nix"];
    lsp.servers.nil-ls.enable = true;
    none-ls.sources = {
      formatting.alejandra.enable = true;
      diagnostics.deadnix.enable = true;
      diagnostics.statix.enable = true;
      code_actions.statix.enable = true;
    };
  };
}
