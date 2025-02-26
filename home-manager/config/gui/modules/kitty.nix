{
  config,
  lib,
  ...
}: let
  inherit (config.homeManagerConfig.gui) enable;
in {
  config.programs.kitty = {
    inherit enable;
    shellIntegration.enableZshIntegration = true;
    # themeFile = "Nord";
    font = {
      name = "Maple Mono NF CN";
      size = 11;
    };
    settings = {
      disable_ligatures = "never";

      cursor_shape = "beam";
      # cursor_trail = 3;

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
      macos_hide_from_tasks = false;
      macos_quit_when_last_window_closed = true;
      macos_menubar_title_max_length = 20;

      paste_actions = "quote-urls-at-prompt";
      clipboard_control = "write-clipboard write-primary read-clipboard read-primary";

      enabled_layouts = "grid";

      # Nordfox colorscheme but shift the background
      foreground = "#cdcecf";
      background = "#2e3441";
      selection_foreground = "#cdcecf";
      selection_background = "#3e4a5b";

      cursor = "#cdcecf";
      cursor_text_color = "#2e3440";

      url_color = "#a3be8c";

      active_border_color = "#81a1c1";
      inactive_border_color = "#5a657d";
      bell_border_color = "#c9826b";

      active_tab_foreground = "#232831";
      active_tab_background = "#81a1c1";
      inactive_tab_foreground = "#60728a";
      inactive_tab_background = "#3e4a5b";

      # black
      color0 = "#3b4252";
      color8 = "#465780";
      # red
      color1 = "#bf616a";
      color9 = "#d06f79";
      # green
      color2 = "#a3be8c";
      color10 = "#b1d196";
      # yellow
      color3 = "#ebcb8b";
      color11 = "#f0d399";
      # blue
      color4 = "#81a1c1";
      color12 = "#8cafd2";
      # magenta
      color5 = "#b48ead";
      color13 = "#c895bf";
      # cyan
      color6 = "#88c0d0";
      color14 = "#93ccdc";
      # white
      color7 = "#e5e9f0";
      color15 = "#e7ecf4";

      color16 = "#c9826b";
      color17 = "#bf88bc";
    }; # settings
    keybindings = {
      "ctrl+shift+t" = "new_tab";
      "super+t" = "new_tab_with_cwd";
      "ctrl+shift+enter" = "new_window";
      "super+enter" = "new_window_with_cwd";
    };
    darwinLaunchOptions = [
      "--single-instance"
      "--directory=~"
    ];
    extraConfig = ''
      font_features MapleMono-NF-CN-Bold             -zero +cv01 -cv02 +cv03 -cv04 -cv98 -cv99 -ss01
      font_features MapleMono-NF-CN-BoldItalic       -zero +cv01 -cv02 +cv03 -cv04 -cv98 -cv99 -ss01
      font_features MapleMono-NF-CN-ExtraBold        -zero +cv01 -cv02 +cv03 -cv04 -cv98 -cv99 -ss01
      font_features MapleMono-NF-CN-ExtraBoldItalic  -zero +cv01 -cv02 +cv03 -cv04 -cv98 -cv99 -ss01
      font_features MapleMono-NF-CN-Light            -zero +cv01 -cv02 +cv03 -cv04 -cv98 -cv99 -ss01
      font_features MapleMono-NF-CN-LightItalic      -zero +cv01 -cv02 +cv03 -cv04 -cv98 -cv99 -ss01
      font_features MapleMono-NF-CN-ExtraLight       -zero +cv01 -cv02 +cv03 -cv04 -cv98 -cv99 -ss01
      font_features MapleMono-NF-CN-ExtraLightItalic -zero +cv01 -cv02 +cv03 -cv04 -cv98 -cv99 -ss01
      font_features MapleMono-NF-CN-Italic           -zero +cv01 -cv02 +cv03 -cv04 -cv98 -cv99 -ss01
      font_features MapleMono-NF-CN-Medium           -zero +cv01 -cv02 +cv03 -cv04 -cv98 -cv99 -ss01
      font_features MapleMono-NF-CN-Regular          -zero +cv01 -cv02 +cv03 -cv04 -cv98 -cv99 -ss01
      font_features MapleMono-NF-CN-SemiBold         -zero +cv01 -cv02 +cv03 -cv04 -cv98 -cv99 -ss01
      font_features MapleMono-NF-CN-SemiBoldItalic   -zero +cv01 -cv02 +cv03 -cv04 -cv98 -cv99 -ss01
      font_features MapleMono-NF-CN-Thin             -zero +cv01 -cv02 +cv03 -cv04 -cv98 -cv99 -ss01
      font_features MapleMono-NF-CN-ThinItalic       -zero +cv01 -cv02 +cv03 -cv04 -cv98 -cv99 -ss01
    '';
  };
}
