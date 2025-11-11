{
  config,
  pkgs,
  ...
}: let
  enable = config.homeManagerConfig.gui.enable && config.homeManagerConfig.gui.software.enable && pkgs.stdenv.isLinux;
in {
  programs.zen-browser.enable = enable;
}
