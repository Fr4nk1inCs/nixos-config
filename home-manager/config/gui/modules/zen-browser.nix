{
  inputs,
  config,
  pkgs,
  ...
}: let
  enable = config.profile.guiSoftwares.enable && pkgs.stdenv.isLinux;
in {
  imports = [
    inputs.zen-browser.homeModules.default
  ];

  programs.zen-browser.enable = enable;
}
