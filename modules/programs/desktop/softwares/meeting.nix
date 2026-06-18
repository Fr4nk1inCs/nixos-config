{
  flake.modules.darwin.desktop = {
    homebrew.casks = [ "tencent-meeting" ];
  };

  flake.modules.homeManager.desktop = { pkgs, lib, ... }: {
    home.packages = lib.optionals pkgs.stdenv.isLinux [
      pkgs.wemeet
    ];
  };
}
