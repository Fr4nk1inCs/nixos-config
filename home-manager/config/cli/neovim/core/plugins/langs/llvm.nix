{pkgs, ...}: {
  programs.nixvim.plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
    mlir
    tablegen
    llvm
  ];
}
