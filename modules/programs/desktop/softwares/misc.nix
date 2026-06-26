{
  flake.modules.darwin.desktop = {
    homebrew.casks = [
      "motrix"
      "pixpin"
    ];
  };

  flake.modules.homeManager.desktop = { pkgs, lib, ... }: {
    home.packages = [
      pkgs.kelivo
      pkgs.inkscape
      pkgs.moonlight-qt
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs.teamspeak6-client
    ];
  };
}
