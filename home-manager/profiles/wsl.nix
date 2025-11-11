{inputs, ...}: {
  imports = [
    ../default.nix
    inputs.zen-browser.homeModules.default
  ];

  homeManagerConfig = {
    gui = {
      enable = true;
      software.enable = true;
    };
  };
}
