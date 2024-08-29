{...}: {
  imports = [
    ../../home-manager
  ];

  homeManagerConfig = {
    system = "wsl";
    gui = {
      enable = false;
    };
  };
}
