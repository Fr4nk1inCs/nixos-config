{
  config,
  inputs,
  ...
}: let
  cfg = config.homeManagerConfig;
  package =
    if cfg.neovimType == "full"
    then "nvim"
    else "minivim";
in {
  imports = [
    inputs.nixCats.homeModule
  ];
  config = {
    home.shellAliases = {
      "vimdiff" = "${package} -d";
      "v" = package;
    };

    home.sessionVariables = {
      EDITOR = package;
    };

    nvim = {
      enable = true;
      packageNames = [package];
    };
  };
}
