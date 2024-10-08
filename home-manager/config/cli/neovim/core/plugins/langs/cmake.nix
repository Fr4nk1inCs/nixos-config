{pkgs, ...}: {
  programs.nixvim.plugins = {
    treesitter.grammarPackages = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.cmake];
    lsp.servers.cmake.enable = true;
    cmake-tools.enable = true;
    none-ls.sources.diagnostics.cmake_lint.enable = true;
  };
}
