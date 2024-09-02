_: {
  programs.nixvim.plugins = {
    markview = {
      enable = true;
    };

    none-ls.sources.formatting.prettier.enable = true;
    none-ls.sources.diagnostics.markdownlint_cli2.enable = true;
  };
}
