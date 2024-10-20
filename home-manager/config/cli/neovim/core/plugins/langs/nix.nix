{
  pkgs,
  flakeRoot,
  ...
}: {
  programs.nixvim.plugins = {
    treesitter.grammarPackages = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.nix];
    lsp.servers.nixd = {
      enable = true;
      settings = {
        nixpkgs.expr = ''import (builtins.getFlake "${flakeRoot}").inputs.nixpkgs {}'';
        options = {
          nixos.expr = ''(builtins.getFlake "${flakeRoot}").nixosConfigurations."wsl".options'';
          home-manager.expr = ''(builtins.getFlake "${flakeRoot}").homeConfigurations."cmdline".options'';
          nix-darwin.expr = ''(builtins.getFlake "${flakeRoot}").homeConfigurations."fr4nk1in-macbook-air".options'';
        };
      };
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
