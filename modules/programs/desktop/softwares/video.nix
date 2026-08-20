{
  flake.modules.darwin.desktop = {
    homebrew.casks = [ "obs" ];
  };

  flake.modules.homeManager.desktop = { pkgs, lib, ... }: {
    home.packages =
      lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        pkgs.obs-studio
        pkgs.mpv
        pkgs.vlc
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
        pkgs.iina
      ];
  };
}
