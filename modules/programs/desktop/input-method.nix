{
  flake.modules.darwin.desktop = {
    homebrew.casks = [ "squirrel-app" ];

    system.defaults.CustomUserPreferences = {
      "com.apple.inputsources".AppleEnabledThirdPartyInputSources = [
        {
          "Bundle ID" = "im.rime.inputmethod.Squirrel";
          "Input Mode" = "im.rime.inputmethod.Squirrel.Hans";
          InputSourceKind = "Input Mode";
        }
        {
          "Bundle ID" = "im.rime.inputmethod.Squirrel";
          InputSourceKind = "Keyboard Input Method";
        }
      ];

      "com.apple.HIToolbox".AppleEnabledInputSources = [
        {
          "Bundle ID" = "com.apple.CharacterPaletteIM";
          InputSourceKind = "Non Keyboard Input Method";
        }
        {
          "Bundle ID" = "com.apple.PressAndHold";
          InputSourceKind = "Non Keyboard Input Method";
        }
        {
          InputSourceKind = "Keyboard Layout";
          "KeyboardLayout ID" = 252;
          "KeyboardLayout Name" = "ABC";
        }
      ];
    };
  };

  flake.modules.homeManager.desktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      yamlFormat = pkgs.formats.yaml { };

      inherit (config.lib.stylix) colors;
      # Squirrel colors are 0xAABBGGRR
      abgr =
        hex:
        "0xff" + lib.substring 4 2 hex + lib.substring 2 2 hex + lib.substring 0 2 hex;

      defaultCustomYaml = yamlFormat.generate "default.custom.yaml" {
        patch = {
          __include = "rime_ice_suggestion:/";

          schema_list = [ { schema = "rime_ice"; } ];

          menu.page_size = 9;
        };
      };

      rimeIceCustomYaml = yamlFormat.generate "rime_ice.custom.yaml" {
        patch."switches/@0/reset" = 1;
      };
    in
    {
      i18n.inputMethod = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        type = "fcitx5";
        enable = true;
        fcitx5 = {
          addons = with pkgs; [
            (fcitx5-rime.override {
              rime-data = rime-ice;
            })
          ];

          settings.addons = {
            clipboard.globalSection.TriggerKey = null;
            rime.globalSection.SwitchInputMethodBehavior = "Commit composing text";
          };

          waylandFrontend = true;
        };
      };

      xdg.dataFile = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        "fcitx5/rime/default.custom.yaml".source = defaultCustomYaml;
        "fcitx5/rime/rime_ice.custom.yaml".source = rimeIceCustomYaml;
      };

      home.activation.rimeDeploy =
        lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin
          (
            let
              rimeDir = "${config.home.homeDirectory}/Library/Rime";
              squirrel = "/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel";
            in
            lib.hm.dag.entryAfter [ "linkGeneration" ] ''
              if [ -d "${rimeDir}" ]; then
                run rm -rf "${rimeDir}/build"
                if [ -x "${squirrel}" ]; then
                  run "${squirrel}" --reload || true
                fi
              fi
            ''
          );

      home.file = lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin (
        {
          "Library/Rime/default.custom.yaml".source = defaultCustomYaml;

          "Library/Rime/rime_ice.custom.yaml".source = rimeIceCustomYaml;

          "Library/Rime/squirrel.custom.yaml".source =
            yamlFormat.generate "squirrel.custom.yaml"
              {
                patch = {
                  "style/color_scheme" = "stylix";
                  "style/color_scheme_dark" = "stylix";

                  "preset_color_schemes/stylix" = {
                    name = "Stylix";
                    author = "Stylix";

                    font_point = 14;
                    label_font_point = 11;
                    comment_font_point = 14;
                    corner_radius = 5;
                    spacing = 6;
                    line_spacing = 4;

                    back_color = abgr colors.base00;
                    border_color = abgr colors.base02;
                    text_color = abgr colors.base05;
                    hilited_text_color = abgr colors.base06;
                    candidate_text_color = abgr colors.base05;
                    hilited_candidate_back_color = abgr colors.base01;
                    hilited_candidate_text_color = abgr colors.base0D;
                    label_color = abgr colors.base03;
                    hilited_candidate_label_color = abgr colors.base0D;
                    comment_text_color = abgr colors.base04;
                    hilited_comment_text_color = abgr colors.base04;
                  };
                };
              };
        }
        //
          lib.mapAttrs'
            (name: _: {
              name = "Library/Rime/${name}";
              value.source = "${pkgs.rime-ice}/share/rime-data/${name}";
            })
            (
              lib.filterAttrs (name: _: name != "build") (
                builtins.readDir "${pkgs.rime-ice}/share/rime-data"
              )
            )
      );
    };
}
