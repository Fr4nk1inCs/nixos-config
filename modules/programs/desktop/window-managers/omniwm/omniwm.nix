{
  flake.modules.homeManager.desktop = { pkgs, lib, ... }: {
    programs.omniwm = lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      enable = true;
      settings = ./settings.toml;
    };
  };
}
