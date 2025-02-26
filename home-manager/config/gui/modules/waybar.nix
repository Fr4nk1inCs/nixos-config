{
  config,
  pkgs,
  ...
}: let
  cfg = config.homeManagerConfig;
  hasBattery = cfg.isMobile;
in {
  config.programs.waybar = {
    enable = cfg.gui.enable && pkgs.stdenv.isLinux;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 25;
        spacing = 0;
        margin = "5 5 0 5";

        modules-left = ["hyprland/workspaces"];
        modules-center = ["custom/spotify"];
        modules-right =
          [
            "tray"
            "custom/dunst"
            "network"
            "bluetooth"
            "cpu"
            "memory"
            "temperature"
            "pulseaudio"
            "backlight"
          ]
          ++ (
            if hasBattery
            then ["battery"]
            else []
          )
          ++ ["clock"];
      };
    }; # settings
  };
}
