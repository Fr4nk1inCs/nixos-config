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
          if pkgs.stdenv.hostPlatform.isDarwin then
            "/Users/${config.home.username}"
          else
            "/home/${config.home.username}";
        stateVersion = "24.05";
      };

      programs.home-manager.enable = true;

      nix.extraOptions = ''
        !include access-tokens.conf
      '';
    };
}
