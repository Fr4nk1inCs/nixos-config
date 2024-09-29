{pkgs, ...}: {
  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    smartcolumn-nvim
  ];
  programs.nixvim.extraConfigLua = ''
    require('smartcolumn').setup({
      disabled_filetypes = {
        "help",
        "text",
        "tex",
        "markdown",
        "dashboard",
        "lazy",
        "mason",
        "neo-tree",
        "help",
        "checkhealth",
        "lspinfo",
        "noice",
        "Trouble",
        "fish",
        "zsh",
        "leetcode.nvim",
      },
    })
  '';
}
