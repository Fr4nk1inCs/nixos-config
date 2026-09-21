{
  flake.modules.darwin.desktop = {
    homebrew.casks = [
      "motrix"
      "pixpin"
    ];
  };

  flake.modules.homeManager.desktop = { pkgs, lib, ... }: {
    home.packages = [
      pkgs.inkscape
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      pkgs.teamspeak6-client
    ];
  };
}
