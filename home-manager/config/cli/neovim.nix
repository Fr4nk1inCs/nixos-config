{
  pkgs,
  config,
  ...
}: let
  cfg = config.homeManagerConfig;
  nixvim =
    if cfg.nixvimConfig.type == "full"
    then
      if cfg.system == "wsl"
      then pkgs.nixvim.fullWsl
      else pkgs.nixvim.full
    else pkgs.nixvim.minimal;
in {
  config = {
    programs.zsh.shellAliases = {
      "vimdiff" = "nvim -d";
      "v" = "nvim";
    };

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    home.packages = [
      nixvim
    ];
  };
}
