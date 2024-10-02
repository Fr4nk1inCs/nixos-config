{
  config,
  lib,
  ...
}: let
  # mod = "super";
  # terminal = "kitty";
  cfg = config.homeManagerConfig;
  enableHyprland = cfg.gui.enable && cfg.system == "linux";
in {
  config.wayland.windowManager.hyprland = lib.optionalAttrs enableHyprland (import ./modules/hyprland.nix);
}
