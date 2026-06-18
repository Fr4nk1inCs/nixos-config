{
  flake.modules.homeManager.desktop = { pkgs, lib, ... }: {
    home.packages = lib.optional pkgs.stdenv.isDarwin pkgs.raycast;
  };
}
