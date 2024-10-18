_: {
  programs.nixvim.plugins.smartcolumn = {
    enable = true;
    settings = {
      disabled_filetypes = [
        "help"
        "text"
        "tex"
        "markdown"
        "dashboard"
        "lazy"
        "mason"
        "neo-tree"
        "help"
        "checkhealth"
        "lspinfo"
        "noice"
        "Trouble"
        "fish"
        "zsh"
        "leetcode.nvim"
      ];
    };
  };
}
