_: {
  flake.modules.darwin.system-minimal = {
    system.stateVersion = 5;

    nix.gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      interval = {
        Weekday = 7;
      };
    };
  };
}
