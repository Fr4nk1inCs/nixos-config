{
  config,
  pkgs,
  ...
}: let
  enable = config.homeManagerConfig.gui.enable && pkgs.stdenv.isLinux;
in {
  services.vicinae = {
    inherit enable;
    autoStart = false;
  };
}
