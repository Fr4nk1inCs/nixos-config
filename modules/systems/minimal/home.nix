_: {
  flake.modules.homeManager.system-minimal =
    {
      config,
      pkgs,
      ...
    }:
    {
      home = {
        homeDirectory =
          if pkgs.stdenv.isDarwin then
            "/Users/${config.home.username}"
          else
            "/home/${config.home.username}";
        stateVersion = "24.05";
        preferXdgDirectories = true;
      };

      xdg = {
        enable = true;
        userDirs.enable = true;
        userDirs.setSessionVariables = true;
      };

      programs.home-manager.enable = true;
    };
}
