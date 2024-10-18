_: {
  programs.nixvim.plugins.auto-session = {
    enable = true;
    settings = {
      cwdChangeHandling = true;
      bypassSessionSaveFileTypes = ["dashboard"];
      autoRestore.enabled = false;
    };
  };
}
