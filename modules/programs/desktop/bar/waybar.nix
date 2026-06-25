{ self, ... }: {
  flake.modules.homeManager.desktop =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      barCfg = self.windowManager.bar;
      scheme = config.lib.stylix.colors;

      # Base palette, pulled straight from the active base16 scheme.
      colors = {
        bg = scheme.base00;
        fg = scheme.base05;
        sel = scheme.base01;
        red = scheme.base08;
        orange = scheme.base09;
        yellow = scheme.base0A;
        green = scheme.base0B;
        cyan = scheme.base0C;
        blue = scheme.base0D;
        magenta = scheme.base0E;
      };

      # Derived colors. GTK's CSS engine has no color-mix(), so these are
      # expressed with GTK's own alpha()/mix() helpers over the palette above.
      derived = {
        bg-panel = "alpha(@bg, 0.85)";
        red-panel = "alpha(@red, 0.85)";
        trough = "mix(@sel, white, 0.15)";
        red-hover = "alpha(mix(@red, white, 0.2), 0.85)";
      };

      defineColor = name: value: "@define-color ${name} ${value};";
      defineColors = lib.concatStringsSep "\n" (
        lib.mapAttrsToList defineColor colors ++ lib.mapAttrsToList defineColor derived
      );

      # waybar.css is authored as standard CSS so biome/treefmt can lint and
      # format it. GTK understands neither custom properties nor var(), so
      # rewrite every var(--name) into a GTK @name reference at build time.
      names = lib.attrNames colors ++ lib.attrNames derived;
      toGtk = builtins.replaceStrings (map (n: "var(--${n})") names) (
        map (n: "@${n}") names
      );

      style = ''
        ${defineColors}

        * {
          font-family: ${config.stylix.fonts.monospace.name};
          font-size:   ${toString config.stylix.fonts.sizes.applications}px;
        }

        ${toGtk (builtins.readFile ./waybar.css)}
      '';
    in
    {
      stylix.targets.waybar.enable = false;

      home.packages = lib.optionals pkgs.stdenv.isLinux (
        with pkgs;
        [
          pavucontrol
          networkmanagerapplet
        ]
      );

      programs.waybar = lib.optionalAttrs pkgs.stdenv.isLinux {
        enable = true;
        inherit style;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 30;
            spacing = 0;
            margin = "5 5 0 5";

            modules-left = [
              "niri/workspaces"
              "niri/window"
            ];
            modules-center = [ "clock" ];
            modules-right =
              if barCfg.backlight.enable then
                [
                  "group/systray"
                  "group/audio"
                  "group/brightness"
                  "group/hardware"
                ]
              else
                [
                  "group/systray"
                  "group/audio"
                  "group/hardware"
                ];

            "niri/window" = {
              icon = true;
              icon-size = 14;
            };

            "group/systray" = {
              orientation = "inherit";
              modules = [
                "tray"
                "network"
                "bluetooth"
              ]; # TODO: add notification
            };
            tray = {
              icon-size = 14;
              spacing = 8;
            };
            network = {
              interval = 3;
              format-wifi = "{icon}";
              format-ethernet = "󰈀";
              format-disconnected = "󰤫";
              format-icons = [
                "󰤯"
                "󰤟"
                "󰤢"
                "󰤥"
                "󰤨"
              ];
              tooltip = true;
              tooltip-format = "{ifname} {ipaddr}/{cidr} 󰇚 {bandwidthDownBytes} 󰕒 {bandwidthUpBytes}";
              tooltip-format-wifi = "{ifname} {ipaddr}/{cidr} {essid}({signalStrength}%) 󰇚 {bandwidthDownBytes} 󰕒 {bandwidthUpBytes}";
              on-click = "nm-connection-editor";
            };
            bluetooth = {
              format = "󰂯";
              format-on = "󰂯";
              format-off = "󰂲";
              format-disabled = "󰂲";
              interval = 10;
              format-connected = "󰂱<span size='3pt'> </span><span size='8pt' baseline_shift='3pt'>{num_connections}</span>";
              tooltip-format = ''
                {controller_alias}${"\t"}{controller_address}

                {num_connections} connected'';
              tooltip-format-connected = ''
                {controller_alias}${"\t"}{controller_address}

                {num_connections} connected

                {device_enumerate}'';
              tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
              tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
              on-click = "blueman-applet";
            };

            "group/audio" = {
              orientation = "inherit";
              modules = [
                "pulseaudio"
                "pulseaudio/slider"
              ];
              drawer = {
                transition-duration = 200;
                children-class = "not-audio";
                transition-left-to-right = true;
              };
            };
            pulseaudio = {
              format = "{icon} {volume}%";
              format-bluetooth = "󰥰";
              format-muted = "󰝟";
              format-icons = {
                hdmi = "󰡁";
                headphone = "󰋋";
                hands-free = "󰋋";
                headset = "󰋎";
                phone = "󰄜";
                portable = "󰏲";
                car = "󰄋";
                default = [
                  "󰕿"
                  "󰖀"
                  "󰕾"
                ];
              };
              tooltip = true;
              tooltip-format = "Device: {desc}\nVolume: {volume}%";
              on-click-right = "pavucontrol";
            };
            "pulseaudio/slider" = {
              min = 0;
              max = 100;
              orientation = "horizontal";
            };

            "group/brightness" = {
              orientation = "inherit";
              modules = [
                "backlight"
                "backlight/slider"
              ];
              drawer = {
                transition-duration = 200;
                children-class = "not-brightness";
                transition-left-to-right = true;
              };
            };
            backlight = {
              device = "intel_backlight";
              format = "{icon} {percent}%";
              format-icons = [
                "󱩎"
                "󱩏"
                "󱩐"
                "󱩑"
                "󱩒"
                "󱩒"
                "󱩔"
                "󱩔"
                "󱩖"
                "󰛨"
              ];
            };
            "backlight/slider" = {
              device = "intel_backlight";
              min = 0;
              max = 100;
              orientation = "horizontal";
            };

            "group/hardware" = {
              orientation = "inherit";
              modules =
                (lib.optional barCfg.battery.enable "battery")
                ++ [
                  "cpu"
                  "memory"
                ]
                ++ (lib.optional barCfg.temperature.enable "temperature");
              drawer = {
                transition-duration = 200;
                children-class = "not-hardware";
                transition-left-to-right = true;
              };
            };
            battery = {
              states = {
                good = 90;
                warning = 30;
                critical = 15;
              };
              format = "{icon} {capacity}%";
              format-charging = "󰂄 {capacity}%";
              format-plugged = "󰂄 {capacity}%";
              format-icons = [
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
            };
            cpu = {
              format = "{icon} {usage}%";
              format-icons = "󰍛";
              interval = 2;
              tooltip = true;
            };
            memory = {
              format = "{icon} {used:0.1f}G";
              format-icons = [
                "󰪞"
                "󰪟"
                "󰪠"
                "󰪡"
                "󰪢"
                "󰪣"
                "󰪤"
                "󰪥"
              ];
              interval = 2;
              tooltip = true;
              tooltip-format = ''
                Memory: {used:0.1f}G / {total:0.1f}G = {percentage}%
                Swap:   {swapUsed}G / {swapTotal}G = {swapPercentage}%'';
            };
            temperature = {
              critical-threshold = 70;
              interval = 2;
              format = "{icon} {temp}°C";
              format-icons = [
                "󰜗"
                "󱃃"
                "󰔏"
                "󱃂"
                "󱗗"
              ];
            };

            clock = {
              locale = "zh_CN.UTF-8";
              format = "{:%m-%d %a %H:%M}";
              tooltip-format = ''
                <big>{:%A, %B %d, %Y}</big>
                {calendar}'';
              calendar = {
                mode = "year";
                mode-mon-col = 3;
                on-scroll = 1;
                on-click-right = "mode";
                format = {
                  "months" = "<span color='${scheme.base05}'><b>{}</b></span>";
                  "days" = "<span color='${scheme.base07}'><b>{}</b></span>";
                  "weekdays" = "<span color='${scheme.base0A}'><b>{}</b></span>";
                  "today" = "<span color='${scheme.base0D}'><b><u>{}</u></b></span>";
                };
              };
            };
          };
        }; # settings
      };
    };
}
