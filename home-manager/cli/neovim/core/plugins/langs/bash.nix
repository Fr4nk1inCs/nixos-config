{pkgs, ...}: {
  programs.nixvim.plugins = {
    lsp.servers.bashls.enable = true;
    conform-nvim.settings.formatters_by_ft = {
      sh = ["shfmt"];
      bash = ["shfmt"];
    };
  };

  programs.nixvim.extraPackages = with pkgs; [shfmt];
}
