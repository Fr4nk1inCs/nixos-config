{
  config,
  lib,
  ...
}: let
  # mod = "super";
  # terminal = "kitty";
  cfg = config.homeManagerConfig;
  enableHyprland = cfg.gui.enable && cfg.system == "linux";
  hyprlandConfiguration = import ./modules/hyprland.nix;
in {
  config.wayland.windowManager.hyprland = lib.optionalAttrs enableHyprland hyprlandConfiguration;
}
