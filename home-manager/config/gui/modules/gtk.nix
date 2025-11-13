{
  config,
  pkgs,
  lib,
  ...
}: let
  override = config.profile.guiSoftwares.enable && pkgs.stdenv.isLinux;
  whitesur-gtk-theme = pkgs.whitesur-gtk-theme-libadwaita-patch.override {
    schemeVariants = ["nord"];
  };
in {
  stylix.targets.gtk.enable = config.profile.guiSoftwares.enable;

  gtk = lib.optionalAttrs override {
    theme = lib.mkForce {
      name = "WhiteSur-Dark-nord";
      package = whitesur-gtk-theme;
    };
  };

  xdg.configFile = lib.optionalAttrs override {
    "gtk-4.0/gtk.css" = lib.mkForce {
      source = "${whitesur-gtk-theme}/config/gtk-4.0/gtk.css";
    };
    "gtk-4.0/assets" = lib.mkForce {
      source = "${whitesur-gtk-theme}/config/gtk-4.0/assets";
      recursive = true;
    };
    "gtk-4.0/windows-assets" = lib.mkForce {
      source = "${whitesur-gtk-theme}/config/gtk-4.0/windows-assets";
      recursive = true;
    };
  };
}
