{
  flake.modules.darwin.desktop = {
    system.defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
      };
    };
  };

  flake.modules.homeManager.desktop = { pkgs, lib, ... }: {
    home.packages = lib.optionals pkgs.stdenv.isLinux [
      pkgs.nautilus
    ];
  };
}
