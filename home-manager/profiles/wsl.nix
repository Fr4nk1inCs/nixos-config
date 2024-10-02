{...}: {
  imports = [
    ../default.nix
  ];

  homeManagerConfig = {
    system = "wsl";
    gui = {
      enable = true;
      software.enable = false;
    };
  };
}
