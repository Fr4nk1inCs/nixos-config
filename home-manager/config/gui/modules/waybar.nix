{
  config,
  pkgs,
  ...
}: let
  inherit (config.homeManagerConfig.gui) enable;
  inherit (config.homeManagerConfig) hasBattery;
in {
  config.programs.waybar = {
    enable = enable && pkgs.stdenv.isLinux;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 25;
        spacing = 0;
        margin = "5 5 0 5";

        modules-left = ["workspaces"];
        modules-center = ["clock"];
        modules-right =
          [
            "tray"
            # "custom/dunst"
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
          );
      };
    }; # settings
  };
}
