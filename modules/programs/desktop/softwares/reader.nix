{
  flake.modules.homeManager.desktop = { pkgs, lib, ... }: {
    home.packages = [
      pkgs.zotero
      pkgs.zathura
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.evince ]
    ++ lib.optionals pkgs.stdenv.isDarwin [ pkgs.skimpdf ];
  };
}
