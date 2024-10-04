{config, ...}: let
  cfg = config.homeManagerConfig;
  enable = cfg.gui.enable && cfg.system == "linux";
  hasBattery = cfg.isMobile;
in {
  config.programs.waybar = {
    inherit enable;
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
