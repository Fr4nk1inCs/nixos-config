{
  flake.modules.darwin.desktop = {
    homebrew.casks = [
      # "onedrive" conflict with office
      "google-drive"
    ];
  };

  flake.modules.homeManager.desktop = { pkgs, lib, ... }: {
    home.packages = [
      pkgs.gdrive3
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs.onedrive
    ];
  };
}
