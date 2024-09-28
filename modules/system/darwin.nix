{lib, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;
    enableSyntaxHighlighting = true;
  };

  nix.gc.interval = lib.mkDefault {
    Weekday = 7;
  };

  services.nix-daemon.enable = true;
}
