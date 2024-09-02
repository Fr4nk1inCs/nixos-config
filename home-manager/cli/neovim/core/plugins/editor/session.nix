_: {
  programs.nixvim.plugins.auto-session = {
    enable = true;
    autoRestore.enabled = false;
    bypassSessionSaveFileTypes = ["dashboard"];
    extraOptions.cwdChangeHandling = true;
  };
}
