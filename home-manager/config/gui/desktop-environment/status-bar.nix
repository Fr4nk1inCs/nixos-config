{config, ...}: let
  cfg = config.homeManagerConfig;
  enableWaybar = cfg.gui.enable && cfg.system == "linux";
  enableSketchyBar = cfg.gui.enable && cfg.system == "darwin";
  hasBattery = cfg.isMobile;
in {
  imports = [
    ./modules/waybar.nix
  ];

  waybarConfig = {
    enable = enableWaybar;
    inherit hasBattery;
  };
}
