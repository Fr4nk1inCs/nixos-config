{
  flake.modules.homeManager.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      tomlFormat = pkgs.formats.toml { };
      rgbaHexToAttrs =
        hex:
        let
          startsWithHash = (builtins.substring 0 1 hex) == "#";
          hexNoHash =
            if startsWithHash then
              builtins.substring 1 (builtins.stringLength hex - 1) hex
            else
              hex;
          hasAlpha = builtins.stringLength hexNoHash == 8;
          hexR = builtins.substring 0 2 hexNoHash;
          hexG = builtins.substring 2 2 hexNoHash;
          hexB = builtins.substring 4 2 hexNoHash;
          hexA = if hasAlpha then builtins.substring 6 2 hexNoHash else "FF";
          hexToFloat = h: builtins.div (lib.fromHexString h) 255.0;
        in
        {
          alpha = hexToFloat hexA;
          red = hexToFloat hexR;
          green = hexToFloat hexG;
          blue = hexToFloat hexB;
        };
    in
    {
      config.lib.nehir = {
        inherit rgbaHexToAttrs;
      };

      options.programs.nehir =
        let
          optionFnGenerator =
            type: defaultValue:
            lib.mkOption {
              inherit type;
              default = defaultValue;
            };

          mkBooleanOption = optionFnGenerator lib.types.bool;
          mkFloatOption = optionFnGenerator lib.types.float;
          mkIntegerOption = optionFnGenerator lib.types.int;
          mkStringOption = optionFnGenerator lib.types.str;

          mkEnumOption = candidates: optionFnGenerator (lib.types.enum candidates);

          mkListOption = type: optionFnGenerator (lib.types.listOf type);

          mkColorOption =
            defaultRgbaHex:
            let
              rgbaAttrs = rgbaHexToAttrs defaultRgbaHex;
            in
            {
              alpha = mkFloatOption rgbaAttrs.alpha;
              red = mkFloatOption rgbaAttrs.red;
              green = mkFloatOption rgbaAttrs.green;
              blue = mkFloatOption rgbaAttrs.blue;
            };

          modKeys = [
            "option"
            "control"
            "command"
            "shift"
            "controlOption"
            "controlCommand"
            "controlShift"
            "controlOptionCommand"
            "controlOptionShift"
            "controlCommandShift"
            "controlOptionCommandShift"
            "optionCommand"
            "optionShift"
            "optionCommandShift"
            "commandShift"
          ];
        in
        {
          enable = lib.mkEnableOption "Enable Nehir window manager";

          settings = {
            appearance.mode = mkEnumOption [ "automatic" "light" "dark" ] "automatic";

            borders = {
              enabled = mkBooleanOption false;

              width = mkFloatOption 1.0;

              color = mkColorOption "#16FFFAFF";
            };

            focus = {
              followsMouse = mkBooleanOption false;
              followsWindowToMonitor = mkBooleanOption false;
              moveMouseToFocusedWindow = mkBooleanOption false;
            };

            gaps = {
              size = mkFloatOption 0.0;

              outer = {
                top = mkFloatOption 0.0;
                bottom = mkFloatOption 0.0;
                left = mkFloatOption 0.0;
                right = mkFloatOption 0.0;
              };
            };

            general = {
              developerModeEnabled = mkBooleanOption false;
              hotkeysEnabled = mkBooleanOption true;
              ipcEnabled = mkBooleanOption false;
              preventSleepEnabled = mkBooleanOption false;
            };

            gestures = {
              fingerCount = mkIntegerOption 3;
              invertDirection = mkBooleanOption false;
              mouseResizeModifierKey = mkEnumOption modKeys "option";
              scrollEnabled = mkBooleanOption false;
              scrollModifierKey = mkEnumOption [ "controlShift" "optionShift" ] "optionShift";
              scrollSensitivity = mkFloatOption 5.0;
            };

            mouseWarp = {
              axis = mkEnumOption [ "horizontal" "vertical" ] "horizontal";
              margin = mkIntegerOption 1;
              monitorOrder = mkListOption lib.types.str [ ];
            };

            niri = {
              balancedColumnCount = mkIntegerOption 2;
              columnWidthPresets = mkListOption lib.types.float [ 0.5 ];
              infiniteLoop = mkBooleanOption false;
              revealPartial = mkEnumOption [
                "none"
                "default"
                "snapClosest"
                "snapCenter"
              ] "default";
            };

            statusBar = {
              showAppNames = mkBooleanOption false;
              showWorkspaceName = mkBooleanOption false;
              useWorkspaceId = mkBooleanOption false;
            };

            workspaceBar = {
              enabled = mkBooleanOption true;
              backgroundOpacity = mkFloatOption 0.0;
              deduplicateAppIcons = mkBooleanOption false;
              height = mkFloatOption 25.0;
              hideEmptyWorkspaces = mkBooleanOption false;
              labelFontSize = mkFloatOption 12.0;
              notchAware = mkBooleanOption true;
              position = mkEnumOption [
                "overlappingMenuBar"
                "belowMenuBar"
              ] "overlappingMenuBar";
              reserveLayoutSpace = mkBooleanOption false;
              showFloatingWindows = mkBooleanOption true;
              showLabels = mkBooleanOption false;
              showTraceButton = mkBooleanOption false;
              windowLevel = mkEnumOption [
                "normal"
                "floating"
                "popup"
                "status"
                "screensaver"
              ] "status";
              xOffset = mkFloatOption 0.0;
              yOffset = mkFloatOption 0.0;

              accentColor = mkColorOption "#007AFFFF";
              textColor = mkColorOption "#000000FF";
            };
          };

          workspaces =
            let
              monitorType =
                lib.types.either
                  (lib.types.submodule {
                    options.monitor = mkEnumOption [ "main" "secondary" ] "main";
                  })
                  (
                    lib.types.submodule {
                      options.displayName = mkStringOption null;
                      options.monitor = mkEnumOption [ "main" "secondary" ] "main";
                    }
                  );
            in
            mkListOption monitorType (
              map (_: {
                monitor = "main";
              }) (lib.range 1 5)
            );

          hotkeys =
            let
              hotkeyOption = mkStringOption "Unassigned";
              mkHotkeyOptionGroups =
                actions:
                builtins.listToAttrs (
                  map (action: {
                    name = action;
                    value = hotkeyOption;
                  }) actions
                );
            in
            {
              workspace = mkHotkeyOptionGroups [
                "switch"
                "moveTo"
                "moveColumnTo"
                "focusAnywhere"
                "backAndForth"
                "next"
                "previous"
                "swapWithMonitorLeft"
                "swapWithMonitorRight"
                "swapWithMonitorUp"
                "swapWithMonitorDown"
              ];

              focus = mkHotkeyOptionGroups [
                "column"
                "windowInColumn"
                "left"
                "down"
                "up"
                "right"
                "previous"
                "downOrLeft"
                "upOrRight"
                "windowTop"
                "windowBottom"
                "windowDownOrTop"
                "windowUpOrBottom"
                "windowOrWorkspaceDown"
                "windowOrWorkspaceUp"
                "columnFirst"
                "columnLast"
                "monitorNext"
                "monitorPrevious"
                "monitorLast"
              ];

              move = mkHotkeyOptionGroups (
                [
                  "columnToIndex"
                  "left"
                  "down"
                  "up"
                  "right"
                  "windowDown"
                  "windowUp"
                  "windowDownOrToWorkspaceDown"
                  "windowUpOrToWorkspaceUp"
                  "windowToWorkspaceUp"
                  "windowToWorkspaceDown"
                  "columnToWorkspaceUp"
                  "columnToWorkspaceDown"
                  "columnLeft"
                  "columnRight"
                  "columnToFirst"
                  "columnToLast"
                  "consumeOrExpelLeft"
                  "consumeOrExpelRight"
                  "consumeIntoColumn"
                  "expelFromColumn"
                ]
                ++ (lib.lists.flatten (
                  map (
                    i:
                    (map (direction: "windowToWorkspaceOnMonitor.${toString i}.${direction}") [
                      "left"
                      "down"
                      "up"
                      "right"
                    ])
                  ) (lib.range 1 9)
                ))
              );

              layout = mkHotkeyOptionGroups [
                "toggleFullscreen"
                "toggleNativeFullscreen"
                "toggleColumnTabbed"
                "toggleColumnFullWidth"
                "expandColumnToAvailable"
                "cycleColumnWidthForward"
                "cycleColumnWidthBackward"
                "cycleWindowWidthForward"
                "cycleWindowWidthBackward"
                "cycleWindowHeightForward"
                "cycleWindowHeightBackward"
                "decreaseColumnWidth"
                "increaseColumnWidth"
                "decreaseWindowWidth"
                "increaseWindowWidth"
                "decreaseWindowHeight"
                "increaseWindowHeight"
                "resetWindowHeight"
                "balanceSizes"
                "scrollViewportLeft"
                "scrollViewportRight"
                "toggleFocusedFloating"
                "assignScratchpad"
                "toggleScratchpad"
                "raiseAllFloating"
                "rescueOffscreen"
              ];

              ui = mkHotkeyOptionGroups [
                "commandPalette"
                "menuAnywhere"
                "settings"
                "toggleOverview"
                "toggleWorkspaceBar"
                "toggleFocusFollowsMouse"
                "toggleFocusFollowsWindowToMonitor"
                "toggleMoveMouseToFocused"
                "toggleBordersEnabled"
                "togglePreventSleepEnabled"
                "toggleIPCEnabled"
              ];

              debugging = mkHotkeyOptionGroups [
                "dumpRuntimeState"
                "resetRuntimeState"
                "restartClearingRuntimeState"
                "toggleTraceCapture"
              ];
            };

          monitors = lib.mkOption {
            type = lib.types.attrsOf lib.types.attrs;
            default = { };

            example = {
              "monitor-x" = {
                match = {
                  name = "Monitor Name";
                  displayId = 2;
                };
                orientation.orientation = "horizontal";
              };
            };
          };

          apprules = lib.mkOption {
            type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
            default = { };
            example = {
              dialog-floating = {
                match = {
                  bundleId = "com.example.productivity-app";
                  axRole = "AXDialog";
                  axSubrole = "AXStandardWindow";
                };
                effect = {
                  layout = "float";
                  assignToWorkspace = "3";
                  minWidth = 480;
                  minHeight = 320;
                };
              };

              pip-floating = {
                match = {
                  bundleId = "com.apple.Safari";
                  titleSubstring = "Picture in Picture";
                };
                effect = {
                  layout = "float";
                  minWidth = 320;
                  minHeight = 180;
                };
              };

              title-regex-workspace = {
                match = {
                  bundleId = "com.example.MyApp";
                  titleRegex = "(?i)(server|logs|deploy)";
                };

                effect = {
                  assignToWorkspace = "2";
                  minWidth = 900;
                  minHeight = 500;
                };
              };
            };
          };
        };

      config.xdg.configFile =
        let
          buildSubConfigs =
            prefix: configs:
            lib.mapAttrs' (name: config: {
              name = "${prefix}/${name}.toml";
              value = {
                source = tomlFormat.generate "${name}.toml" config;
              };
            }) configs;
        in
        lib.mkIf config.programs.nehir.enable (
          {
            "nehir/settings.toml".source =
              tomlFormat.generate "settings.toml" config.programs.nehir.settings;
            "nehir/workspaces.toml".source = tomlFormat.generate "workspaces.toml" (
              builtins.listToAttrs (
                lib.imap1 (i: workspace: {
                  name = "${toString i}";
                  value = workspace;
                }) config.programs.nehir.workspaces
              )
            );
            "nehir/hotkeys.toml".source =
              tomlFormat.generate "hotkeys.toml" config.programs.nehir.hotkeys;
          }
          // buildSubConfigs "nehir/monitors.d" config.programs.nehir.monitors
          // buildSubConfigs "nehir/apprules.d" config.programs.nehir.apprules
        );
    };
}
