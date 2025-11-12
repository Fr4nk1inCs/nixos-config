{inputs, ...}: {
  imports = [
    ../default.nix
    inputs.vicinae.homeManagerModules.default
  ];

  homeManagerConfig = {
    gui = {
      enable = true;
      software.enable = true;
    };
  };
}
