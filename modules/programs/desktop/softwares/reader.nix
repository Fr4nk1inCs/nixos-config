{
  flake.modules.homeManager.desktop = { pkgs, lib, ... }: {
    home.packages = [
      pkgs.zotero
      pkgs.zathura
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.evince ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.skimpdf ];
  };
}
