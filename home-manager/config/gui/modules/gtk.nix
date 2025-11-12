{
  config,
  pkgs,
  lib,
  ...
}: let
  override = config.profile.guiSoftwares.enable && pkgs.stdenv.isLinux;
  whitesur-gtk-theme =
    if pkgs.stdenv.isLinux
    then
      (pkgs.whitesur-gtk-theme.override {
        schemeVariants = ["nord"];
      }).overrideAttrs (_: prev: {
        pname = "whitesur-gtk-theme-libadwaita-patch";
        postPatch =
          prev.postPatch
          + ''
            substituteInPlace libs/lib-install.sh --replace-fail '"''${HOME}/.config/gtk-4.0"' '"$out/config/gtk-4.0"'
            substituteInPlace install.sh --replace-fail '"''${libadwaita}"' '"true"'
            substituteInPlace install.sh --replace-fail '"$UID"' '"1"'
          '';
      })
    else null;
in {
  stylix.targets.gtk.enable = config.profile.guiSoftwares.enable;

  gtk = lib.optionalAttrs override {
    theme = lib.mkForce {
      name = "WhiteSur-Dark-nord";
      package = whitesur-gtk-theme;
    };
  };

  xdg.configFile = lib.optionalAttrs override {
    # NOTE: `toString` is needed since the `mkForce`d attrsets are still
    # evaluated and `null` cannot be coerced to a string
    "gtk-4.0/gtk.css" = lib.mkForce {
      source = "${toString whitesur-gtk-theme}/config/gtk-4.0/gtk.css";
    };
    "gtk-4.0/assets" = lib.mkForce {
      source = "${toString whitesur-gtk-theme}/config/gtk-4.0/assets";
      recursive = true;
    };
    "gtk-4.0/windows-assets" = lib.mkForce {
      source = "${toString whitesur-gtk-theme}/config/gtk-4.0/windows-assets";
      recursive = true;
    };
  };
}
