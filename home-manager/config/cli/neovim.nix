{
  inputs,
  config,
  ...
}: let
  package = config.profile.neovimPackage;
in {
  imports = [
    inputs.nixCats.homeModule
  ];

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
}
