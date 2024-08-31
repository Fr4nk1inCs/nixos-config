_: {
  programs.nixvim.plugins.toggleterm = {
    enable = true;
    settings = {
      direction = "float";
      float_opts = {
        border = "curved";
        width.__raw = ''function(_) return math.floor(vim.o.columns * 0.9) end'';
        height.__raw = ''function(_) return math.floor(vim.o.lines * 0.9) end'';
      };
      winbar.enabled = true;
      open_mapping = "[[<c-\\>]]";
    };
  };
}
