{lib, ...}: {
  imports = [
    ../default.nix
  ];

  homeManagerConfig = {
    gui = {
      enable = false;
      software.enable = false;
    };
    extraProgramConfig = {
      wezterm.enable = lib.mkForce true;
    };
  };
}
