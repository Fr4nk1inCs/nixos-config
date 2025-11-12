{
  config,
  pkgs,
  lib,
  ...
}: let
  enable = config.profile.windowManager.enable && pkgs.stdenv.isLinux;
  whitesur-gtk-theme =
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
    });
in {
  gtk = lib.mkForce {
    inherit enable;
    theme = {
      name = "WhiteSur-Dark-nord";
      package = whitesur-gtk-theme;
    };
  };

  xdg.configFile = lib.optionalAttrs enable {
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
