{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.homeManagerConfig;
  enable = cfg.gui.enable && pkgs.stdenv.isDarwin;
  triggerSketchybarEvent = pkgs.writeShellScript "aerospace-trigger-workspace-change.sh" ''
    ${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change \
        FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE \
        PREV_WORKSPACE=$AEROSPACE_PREV_WORKSPACE
  '';
in {
  config = lib.mkIf enable {
    home.packages = [pkgs.aerospace];
    xdg.configFile."aerospace/aerospace.toml" = {
      text = inputs.nix-std.lib.serde.toTOML {
        start-at-login = false;

        after-startup-command = [
          "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=0xff81a1c1 inactive_color=0xff2e3440 width=2.0"
          "workspace 8"
          "layout accordion"
          "workspace-back-and-forth"
        ];

        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";

        key-mapping.preset = "qwerty";

        on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
        on-focus-changed = ["move-mouse window-lazy-center"];

        exec-on-workspace-change = [
          (toString triggerSketchybarEvent)
        ];

        gaps = {
          inner = {
            horizontal = 5;
            vertical = 5;
          };
          outer = {
            left = 5;
            right = 5;
            top = 5;
            bottom = 30;
          };
        };

        mode = {
          main.binding = {
            alt-enter = "exec-and-forget ${pkgs.kitty}/bin/kitty --directory ~";

            alt-slash = "layout tiles horizontal vertical";
            alt-comma = "layout accordion horizontal vertical";

            alt-h = "focus left";
            alt-j = "focus down";
            alt-k = "focus up";
            alt-l = "focus right";

            alt-shift-h = "move left";
            alt-shift-j = "move down";
            alt-shift-k = "move up";
            alt-shift-l = "move right";

            alt-1 = "workspace 1";
            alt-2 = "workspace 2";
            alt-3 = "workspace 3";
            alt-4 = "workspace 4";
            alt-5 = "workspace 5";
            alt-6 = "workspace 6";
            alt-7 = "workspace 7";
            alt-8 = "workspace 8";
            alt-9 = "workspace 9";
            alt-0 = "workspace 10";

            alt-shift-1 = "move-node-to-workspace 1";
            alt-shift-2 = "move-node-to-workspace 2";
            alt-shift-3 = "move-node-to-workspace 3";
            alt-shift-4 = "move-node-to-workspace 4";
            alt-shift-5 = "move-node-to-workspace 5";
            alt-shift-6 = "move-node-to-workspace 6";
            alt-shift-7 = "move-node-to-workspace 7";
            alt-shift-8 = "move-node-to-workspace 8";
            alt-shift-9 = "move-node-to-workspace 9";
            alt-shift-0 = "move-node-to-workspace 10";

            alt-space = "layout floating tiling";
            alt-m = "fullscreen";
            alt-f = "macos-native-fullscreen";

            alt-q = "close";

            alt-tab = "workspace-back-and-forth";
            alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

            alt-semicolon = "mode command";
            alt-r = "mode resize";
          };
          command.binding = {
            esc = ["reload-config" "mode main"];
            r = ["flatten-workspace-tree" "mode main"];

            h = ["join-with left" "mode main"];
            j = ["join-with down" "mode main"];
            k = ["join-with up" "mode main"];
            l = ["join-with right" "mode main"];
          };
          resize.binding = {
            esc = "mode main";

            minus = "resize smart -50";
            equal = "resize smart +50";
          };
        };

        on-window-detected = [
          {
            "if".app-id = "com.apple.mail";
            run = ["move-node-to-workspace 8"];
          }
          {
            "if".app-id = "com.tdesktop.Telegram";
            run = ["move-node-to-workspace 8"];
          }
          {
            "if".app-id = "com.tencent.qq";
            run = ["move-node-to-workspace 8"];
          }
          {
            "if".app-id = "com.tencent.xinWeChat";
            run = ["move-node-to-workspace 8"];
          }
          {
            "if".app-id = "com.alibaba.DingTalkMac";
            run = ["move-node-to-workspace 8"];
          }
          {
            "if".app-id = "com.spotify.client";
            run = ["move-node-to-workspace 7"];
          }
          {
            "if".app-id = "com.apple.Music";
            run = ["move-node-to-workspace 7"];
          }
        ];
        workspace-to-monitor-force-assignment = {
          "7" = "built-in";
          "8" = "built-in";
        };
      };
    };
  };
}
