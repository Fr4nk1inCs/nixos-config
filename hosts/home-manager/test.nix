{pkgs, ...}: {
  imports = [
    ../../home-manager
  ];

  homeManagerConfig = {
    username = "test";
    gui = {
      enable = true;
      software.enable = false;
    };
  };
}
