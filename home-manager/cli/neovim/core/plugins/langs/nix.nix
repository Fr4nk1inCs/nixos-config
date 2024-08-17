{pkgs, ...}: {
  programs.nixvim.plugins = {
    treesitter.settings.ensure_installed = ["nix"];
    lsp.servers.nil-ls.enable = true;
    conform-nvim.settings.formatters_by_ft = {nix = ["alejandra"];};
  };

  programs.nixvim.extraPackages = with pkgs; [alejandra];
}
