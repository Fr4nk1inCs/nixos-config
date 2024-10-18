_: {
  programs.nixvim.plugins.auto-session = {
    enable = true;
    settings = {
      auto_restore = false;
      cwd_change_handling = true;
      bypass_save_filetypes = ["dashboard"];
    };
  };
}
