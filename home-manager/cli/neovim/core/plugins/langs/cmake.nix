{pkgs, ...}: {
  programs.nixvim.plugins = {
    treesitter.settings.ensure_installed = ["cmake"];
    lsp.servers.cmake.enable = true;
    cmake-tools.enable = true;
    lint.lintersByFt = {cmake = ["cmakelint"];};
  };

  programs.nixvim.extraPackages = with pkgs; [cmake-lint];
}
