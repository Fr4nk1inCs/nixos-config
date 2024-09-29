_: {
  programs.nixvim.plugins = {
    notify = {
      enable = true;
      backgroundColour = "#000000";
      stages = "static";
      timeout = 3000;
      maxHeight.__raw = ''
        function()
          return math.floor(vim.o.lines * 0.75)
        end
      '';
      maxWidth.__raw = ''
        function()
          return math.floor(vim.o.columns * 0.75)
        end
      '';
      onOpen.__raw = ''
        function(win)
          vim.api.nvim_win_set_config(win, { zindex = 100 })
        end
      '';
    };
  };

  programs.nixvim.keymaps = [
    {
      key = "<leader>un";
      mode = "n";
      action.__raw = ''
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end
      '';
      options = {
        desc = "Dismiss All Notifications";
        silent = true;
      };
    }
  ];
}
