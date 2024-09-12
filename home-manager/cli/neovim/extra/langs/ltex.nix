{
  config,
  lib,
  ...
}: let
  enable = config.homeManagerConfig.nixvimConfig.type == "full";
in {
  config = lib.mkIf enable {
    programs.nixvim.plugins.ltex-extra = {
      enable = true;
      settings = {
        load_langs = ["en-US" "zh-CN"];
        path = ".ltex";
      };
    };
  };
}
