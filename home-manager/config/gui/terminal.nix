{
  config,
  lib,
  ...
}: let
  inherit (config.homeManagerConfig.gui) enable;
in {
  config.programs.kitty = lib.mkIf enable (import ./modules/kitty.nix);
  config.programs.wezterm = lib.mkIf enable (import ./modules/wezterm.nix);
}
