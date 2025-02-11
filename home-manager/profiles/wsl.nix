{...}: {
  imports = [
    ../default.nix
  ];

  homeManagerConfig = {
    gui = {
      enable = false;
      software.enable = false;
    };
  };
}
