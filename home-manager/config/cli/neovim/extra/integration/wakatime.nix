{config, ...}: let
  enable = config.homeManagerConfig.nixvimConfig.type == "full";
in {
  config.programs.nixvim.plugins.wakatime.enable = enable;
}
