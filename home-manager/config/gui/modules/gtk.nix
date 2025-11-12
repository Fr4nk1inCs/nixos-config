{
  config,
  pkgs,
  lib,
  ...
}: let
  enable = config.homeManagerConfig.gui.enable && pkgs.stdenv.isLinux;
in {
  gtk = {
    inherit enable;
    theme = lib.mkForce {
      name = "WhiteSur-Dark-nord";
      package = pkgs.whitesur-gtk-theme.override {
        schemeVariants = ["nord"];
      };
    };
  };
}
