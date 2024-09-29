{
  lib,
  config,
  ...
}: {
  options = {
    waybarConfig = {
      enable = lib.mkEnableOption "Enable Waybar";
      hasBattery = lib.mkOption {
        default = false;
        description = "Enable battery module";
      };
    };
  };
  programs.waybar = {
    enable = true;
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
            if config.options.hasBattery
            then ["battery"]
            else []
          )
          ++ ["clock"];
      };
    }; # settings
  };
}
