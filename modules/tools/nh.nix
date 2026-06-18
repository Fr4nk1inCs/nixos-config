{
  flake.modules = {
    nixos.nh = {
      programs.nh = {
        enable = true;
        clean.enable = true;
      };
    };

    homeManager.nh = { config, ... }: {
      programs.nh = {
        enable = true;
        clean.enable = true;
        flake = "${config.home.homeDirectory}/nixos-config";
      };
    };
  };
}
