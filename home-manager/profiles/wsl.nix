{...}: {
  imports = [
    ../default.nix
  ];

  homeManagerConfig = {
    system = "wsl";
    gui = {
      enable = false;
    };
  };
}
