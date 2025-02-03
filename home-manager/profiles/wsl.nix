{...}: {
  imports = [
    ../default.nix
  ];

  homeManagerConfig = {
    gui = {
      enable = true;
      software.enable = false;
    };
  };
}
