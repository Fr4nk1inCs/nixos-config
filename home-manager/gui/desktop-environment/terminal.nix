{
  config,
  lib,
  ...
}: let
  inherit (config.homeManagerConfig.gui) enable;
in {
  config.programs.kitty = lib.optionalAttrs enable {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    theme = "Nord";
    font = {
      name = "Maple Mono NF CN";
      size = 11.5;
    };
    keybindings = {}; # keybindings
    settings = {
      disable_ligatures = "never";

      cursor_shape = "beam";

      scrollback_lines = 10000;

      strip_trailing_spaces = "smart";

      tab_bar_edge = "top";
    }; # settings
    extraConfig = ''
      font_features MapleMono-NF-CN-Bold             -zero +cv01 -cv02 +cv03 -cv04 -cv99 -ss01
      font_features MapleMono-NF-CN-BoldItalic       -zero +cv01 -cv02 +cv03 -cv04 -cv99 -ss01
      font_features MapleMono-NF-CN-ExtraBold        -zero +cv01 -cv02 +cv03 -cv04 -cv99 -ss01
      font_features MapleMono-NF-CN-ExtraBoldItalic  -zero +cv01 -cv02 +cv03 -cv04 -cv99 -ss01
      font_features MapleMono-NF-CN-Light            -zero +cv01 -cv02 +cv03 -cv04 -cv99 -ss01
      font_features MapleMono-NF-CN-LightItalic      -zero +cv01 -cv02 +cv03 -cv04 -cv99 -ss01
      font_features MapleMono-NF-CN-ExtraLight       -zero +cv01 -cv02 +cv03 -cv04 -cv99 -ss01
      font_features MapleMono-NF-CN-ExtraLightItalic -zero +cv01 -cv02 +cv03 -cv04 -cv99 -ss01
      font_features MapleMono-NF-CN-Italic           -zero +cv01 -cv02 +cv03 -cv04 -cv99 -ss01
      font_features MapleMono-NF-CN-Medium           -zero +cv01 -cv02 +cv03 -cv04 -cv99 -ss01
      font_features MapleMono-NF-CN-Regular          -zero +cv01 -cv02 +cv03 -cv04 -cv99 -ss01
      font_features MapleMono-NF-CN-SemiBold         -zero +cv01 -cv02 +cv03 -cv04 -cv99 -ss01
      font_features MapleMono-NF-CN-SemiBoldItalic   -zero +cv01 -cv02 +cv03 -cv04 -cv99 -ss01
      font_features MapleMono-NF-CN-Thin             -zero +cv01 -cv02 +cv03 -cv04 -cv99 -ss01
      font_features MapleMono-NF-CN-ThinItalic       -zero +cv01 -cv02 +cv03 -cv04 -cv99 -ss01
    '';
  };
}
