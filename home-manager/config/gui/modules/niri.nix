{
  pkgs,
  lib,
  config,
  ...
}: let
  enable = config.homeManagerConfig.gui.enable && pkgs.stdenv.hostPlatform.isLinux;
  HOME = config.home.homeDirectory;
in {
  home.packages = lib.mkIf enable (with pkgs; [
    blueman
  ]);

  programs.niri = lib.mkIf enable {
    settings = {
      screenshot-path = "${HOME}/Pictures/Screenshots/screenshot-%Y-%m-%d-%H%M%S.png";
      prefer-no-csd = true;
      environment."NIXOS_OZONE_WL" = "1";

      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite;
      };

      spawn-at-startup = [
        {sh = "echo $NIRI_SOCKET > ${HOME}/.niri-socket";}
        {argv = ["waybar"];}
        {argv = ["vicinae" "server"];}
        {argv = ["blueman-applet"];}
      ];

      input = {
        inherit (config.homeManagerConfig.gui) mod-key mod-key-nested;
        focus-follows-mouse.enable = true;
        keyboard = {
          numlock = true;
          repeat-delay = 225;
          repeat-rate = 33;
        };
      };

      outputs = {
        "Smithay Winit Unknown" = {
          enable = true;
          focus-at-startup = true;
          scale = 1.5;
          mode = {
            height = 2056;
            width = 3840;
            refresh = 160.0;
          };
        };
      };

      layout = {
        border = {
          enable = true;
          width = 2;
        };
        focus-ring = {
          enable = true;
          width = 2;
        };
        shadow = {
          enable = true;
          offset = {
            x = 0;
            y = 0;
          };
        };
        gaps = 10;
      };

      window-rules = [
        {
          geometry-corner-radius = {
            bottom-left = 10.0;
            bottom-right = 10.0;
            top-left = 10.0;
            top-right = 10.0;
          };
          clip-to-geometry = true;
          opacity = 0.95;
        }
      ];

      binds = with config.lib.niri.actions; let
        screenshot = {screenshot = [];};
        screenshot-screen = {screenshot-screen = [];};
        screenshot-window = {screenshot-window = [];};

        move-column-to-workspace = workspace: {move-column-to-workspace = workspace;};
      in {
        "Mod+Shift+S".action = show-hotkey-overlay;
        "Mod+Shift+E".action = quit;
        "Ctrl+Alt+Delete".action = quit;

        "Mod+Return".action = spawn "ghostty" "+new-window";
        "Mod+Space" = {
          action = spawn "vicinae" "toggle";
          repeat = false;
        };
        "Mod+A" = {
          action = spawn "vicinae" "toggle";
          repeat = false;
        };

        "Mod+O".action = toggle-overview;

        "Mod+Q".action = close-window;

        "Mod+F".action = fullscreen-window;
        "Mod+M".action = maximize-column;

        "Mod+C".action = center-column;
        "Mod+Shift+C".action = center-visible-columns;

        "Mod+Shift+Space".action = toggle-window-floating;
        "Mod+Shift+F".action = switch-focus-between-floating-and-tiling;

        "Mod+W".action = toggle-column-tabbed-display;

        # screenshot
        "Print".action = screenshot;
        "Ctrl+Print".action = screenshot-screen;
        "Shift+Print".action = screenshot-window;

        # window size
        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        # focus
        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;

        # move
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+J".action = move-window-down;
        "Mod+Shift+K".action = move-window-up;

        # focus workspace
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;

        "Mod+Comma".action = focus-workspace-up;
        "Mod+Period".action = focus-workspace-down;

        # move to workspace
        "Mod+Shift+1".action = move-column-to-workspace 1;
        "Mod+Shift+2".action = move-column-to-workspace 2;
        "Mod+Shift+3".action = move-column-to-workspace 3;
        "Mod+Shift+4".action = move-column-to-workspace 4;
        "Mod+Shift+5".action = move-column-to-workspace 5;
        "Mod+Shift+6".action = move-column-to-workspace 6;
        "Mod+Shift+7".action = move-column-to-workspace 7;
        "Mod+Shift+8".action = move-column-to-workspace 8;
        "Mod+Shift+9".action = move-column-to-workspace 9;

        "Mod+Shift+Comma".action = move-column-to-workspace-up;
        "Mod+Shift+Period".action = move-column-to-workspace-down;

        # workspace movement
        "Mod+Ctrl+Comma".action = move-workspace-up;
        "Mod+Ctrl+Period".action = move-workspace-down;
      };
    };
  };
}
