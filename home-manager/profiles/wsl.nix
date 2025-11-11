{inputs, ...}: {
  imports = [
    ../default.nix
    inputs.zen-browser.homeModules.default
    inputs.vicinae.homeManagerModules.default
  ];

  homeManagerConfig = {
    gui = {
      enable = true;
      software.enable = true;
    };
  };
}
