{
  config,
  lib,
  ...
}: let
  inherit (config.homeManagerConfig.gui) enable;
in {
  config.programs.kitty =
    lib.mkIf enable
    {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      themeFile = "Nord";
      font = {
        name = "Maple Mono NF CN";
        size = 11;
      };
      keybindings = {}; # keybindings
      settings = {
        disable_ligatures = "never";

        cursor_shape = "beam";

        scrollback_lines = 10000;

        strip_trailing_spaces = "smart";

        hide_window_decorations = "titlebar-only";

        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_powerline_style = "round";
        tab_activity_symbol = "!";
        tab_title_template = "• {bell_symbol}{activity_symbol}{index}:{title}";
        active_tab_title_template = "⦿ {bell_symbol}{activity_symbol}{index}:{title}";

        background_opacity = "0.8";
        background_blur = 15;

        macos_option_as_alt = true;
        macos_hide_from_tasks = true;
        macos_quit_when_last_window_closed = true;
        macos_menubar_title_max_length = 20;
      }; # settings
      darwinLaunchOptions = [
        "--single-instance"
        "--directory=~"
      ];
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
