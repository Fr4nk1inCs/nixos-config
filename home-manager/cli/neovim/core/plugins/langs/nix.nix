{pkgs, ...}: {
  programs.nixvim.plugins = {
    treesitter.settings.ensure_installed = ["nix"];
    lsp.servers.nil-ls.enable = true;
    none-ls.sources.formatting.alejandra.enable = true;
    none-ls.sources.diagnostics.deadnix.enable = true;
    none-ls.sources.diagnostics.statix.enable = true;
    none-ls.sources.code_actions.statix.enable = true;
  };
}
