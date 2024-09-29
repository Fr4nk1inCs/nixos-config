{...}: {
  imports = [
    ../default.nix
  ];

  homeManagerConfig = {
    username = "test";
    gui = {
      enable = true;
      software.enable = false;
    };
  };
}
