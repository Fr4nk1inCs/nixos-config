{
  pkgs,
  lib,
  ...
}: {
  stylix = lib.mkIf pkgs.stdenv.isLinux {
    image = ./assets/rick-4k.png;

    fonts = {
      sansSerif = {
        name = "Inter Display";
        package = pkgs.inter;
      };
      serif = {
        name = "Source Han Serif SC";
        package = pkgs.source-han-serif;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
    };

    cursor = {
      name = "WhiteSur-cursors";
      package = pkgs.whitesur-cursors;
      size = 24;
    };

    icons = {
      enable = true;
      package = pkgs.whitesur-icon-theme.override {
        themeVariants = ["nord"];
      };
      dark = "WhiteSur-nord-dark";
      light = "WhiteSur-nord-light";
    };
  };
}
