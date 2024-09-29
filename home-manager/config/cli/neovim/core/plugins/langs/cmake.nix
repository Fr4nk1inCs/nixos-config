_: {
  programs.nixvim.plugins = {
    treesitter.settings.ensure_installed = ["cmake"];
    lsp.servers.cmake.enable = true;
    cmake-tools.enable = true;
    none-ls.sources.diagnostics.cmake_lint.enable = true;
  };
}
