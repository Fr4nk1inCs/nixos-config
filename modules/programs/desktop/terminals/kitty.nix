{ self, ... }: {
  flake.modules.homeManager.desktop = { lib, ... }: {
    programs.kitty = {
      enable = true;

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
        tab_title_template = lib.concatStrings [
          "• "
          "{bell_symbol}"
          "{activity_symbol}"
          "{index}:{title}"
        ];
        active_tab_title_template = lib.concatStrings [
          "⦿ "
          "{bell_symbol}"
          "{activity_symbol}"
          "{index}:{title}"
        ];

        background_blur = 20;

        macos_option_as_alt = true;
        macos_hide_from_tasks = false;
        macos_quit_when_last_window_closed = true;
        macos_menubar_title_max_length = 20;

        paste_actions = "quote-urls-at-prompt";
        clipboard_control = lib.concatStringsSep " " [
          "write-clipboard"
          "write-primary"
          "read-clipboard"
          "read-primary"
        ];

        enabled_layouts = "grid";
      };

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

      extraConfig =
        let
          inherit (self.lib.fontFeatures) toHarfBuzz;
          fontWeightsAndStyles = [
            "Bold"
            "BoldItalic"
            "ExtraBold"
            "ExtraBoldItalic"
            "Light"
            "LightItalic"
            "ExtraLight"
            "ExtraLightItalic"
            "Italic"
            "Medium"
            "Regular"
            "SemiBold"
            "SemiBoldItalic"
            "Thin"
            "ThinItalic"
          ];
          mkFontName = weightAndStyle: "Maple-Mono-NF-CN-${weightAndStyle}";
          fontFeatures = self.constants.fontFeatures.maple-mono;
          fontFeaturesStr = lib.concatStringsSep " " (toHarfBuzz fontFeatures);
        in
        lib.concatLines (
          map (
            weightAndStyle:
            lib.concatStringsSep " " [
              "font_features"
              (mkFontName weightAndStyle)
              fontFeaturesStr
            ]
          ) fontWeightsAndStyles
        );
    };
  };
}
