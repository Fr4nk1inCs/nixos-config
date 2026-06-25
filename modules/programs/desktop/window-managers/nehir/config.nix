{
  flake.modules.darwin.desktop = {
    homebrew = {
      taps = [
        {
          name = "guria/tap";
          trusted = true;
        }
      ];

      casks = [
        "guria/tap/nehir"
      ];
    };
  };

  flake.modules.homeManager.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.nehir = lib.optionalAttrs pkgs.stdenv.isDarwin {
        enable = true;

        settings =
          let
            rgba = color: alpha: config.lib.nehir.rgbaHexToAttrs "${color}${alpha}";
          in
          {
            appearance.mode = "automatic";

            borders.enabled = false;

            focus = {
              followsMouse = true;
              followsWindowToMonitor = true;
              moveMouseToFocusedWindow = true;
            };

            gaps = {
              size = 5.0;
              outer.top = 5.0;
            };

            general = {
              hotkeysEnabled = true;
              ipcEnabled = true;
            };

            gestures = {
              fingerCount = 3;
              mouseResizeModifierKey = "option";
              invertDirection = true;
              scrollEnabled = true;
              scrollModifierKey = "optionShift";
            };

            mouseWarp = {
              axis = "horizontal";
              margin = 1;
              # `monitorOrder` is handled by host
            };

            niri = {
              columnWidthPresets = [
                0.33
                0.5
                0.66
              ];
              infiniteLoop = true;
              revealPartial = "default";
            };

            workspaceBar = {
              enabled = true;
              backgroundOpacity = 0.0;
              deduplicateAppIcons = false;
              height = 20.0;
              hideEmptyWorkspaces = false;
              labelFontSize = config.stylix.fonts.sizes.applications + 0.0;
              notchAware = false;
              position = "overlappingMenuBar";
              reserveLayoutSpace = false;
              showFloatingWindows = true;
              showLabels = true;
              showTraceButton = false;
              windowLevel = "status";
              xOffset = 0.0;
              yOffset = -10.0;

              accentColor = rgba config.lib.stylix.colors.base0D "ff";
              textColor = rgba "#000000" "ff";
            };

          };

        workspaces =
          (map (_: {
            monitor = "main";
          }) (lib.range 1 5))
          ++ (map (_: {
            monitor = "secondary";
          }) (lib.range 6 9));

        hotkeys =
          let
            mod = key: "Option+${key}";
            modShift = key: "Option+Shift+${key}";
          in
          {
            ui = {
              commandPalette = modShift "P";
              toggleOverview = mod "O";
              menuAnywhere = modShift "M";
            };

            layout = {
              toggleFullscreen = mod "M";
              toggleNativeFullscreen = mod "F";

              expandColumnToAvailable = mod "E";

              toggleFocusedFloating = modShift "Space";
              raiseAllFloating = modShift "F";

              decreaseColumnWidth = mod "Minus";
              increaseColumnWidth = mod "Equal";
              decreaseWindowHeight = modShift "Minus";
              increaseWindowHeight = modShift "Equal";
              cycleColumnWidthForward = mod "R";

              assignScratchpad = modShift "Backslash";
              toggleScratchpad = mod "Backslash";
            };

            focus = {
              left = mod "H";
              right = mod "L";
              down = mod "J";
              up = mod "K";
            };

            move = {
              left = modShift "H";
              right = modShift "L";
              down = modShift "J";
              up = modShift "K";

              windowToWorkspaceUp = modShift "Comma";
              windowToWorkspaceDown = modShift "Period";
            };

            workspace = {
              switch = mod "{N}";
              moveTo = modShift "{N}";
              previous = mod "Comma";
              next = mod "Period";
              backAndForth = mod "Tab";
            };
          };
      };
    };
}
