{config, ...}: let
  inherit (config.profile.guiSoftwares) enable;
in {
  config.programs.kitty = {
    inherit enable;
    shellIntegration.enableZshIntegration = true;
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

      background_blur = 20;

      macos_option_as_alt = true;
      macos_hide_from_tasks = false;
      macos_quit_when_last_window_closed = true;
      macos_menubar_title_max_length = 20;

      paste_actions = "quote-urls-at-prompt";
      clipboard_control = "write-clipboard write-primary read-clipboard read-primary";

      enabled_layouts = "grid";
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
      font_features MapleMono-NF-CN-Bold             +calt +cv01 +cv03 +ss03
      font_features MapleMono-NF-CN-BoldItalic       +calt +cv01 +cv03 +ss03
      font_features MapleMono-NF-CN-ExtraBold        +calt +cv01 +cv03 +ss03
      font_features MapleMono-NF-CN-ExtraBoldItalic  +calt +cv01 +cv03 +ss03
      font_features MapleMono-NF-CN-Light            +calt +cv01 +cv03 +ss03
      font_features MapleMono-NF-CN-LightItalic      +calt +cv01 +cv03 +ss03
      font_features MapleMono-NF-CN-ExtraLight       +calt +cv01 +cv03 +ss03
      font_features MapleMono-NF-CN-ExtraLightItalic +calt +cv01 +cv03 +ss03
      font_features MapleMono-NF-CN-Italic           +calt +cv01 +cv03 +ss03
      font_features MapleMono-NF-CN-Medium           +calt +cv01 +cv03 +ss03
      font_features MapleMono-NF-CN-Regular          +calt +cv01 +cv03 +ss03
      font_features MapleMono-NF-CN-SemiBold         +calt +cv01 +cv03 +ss03
      font_features MapleMono-NF-CN-SemiBoldItalic   +calt +cv01 +cv03 +ss03
      font_features MapleMono-NF-CN-Thin             +calt +cv01 +cv03 +ss03
      font_features MapleMono-NF-CN-ThinItalic       +calt +cv01 +cv03 +ss03
    '';
  };
}
