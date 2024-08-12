{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./core
    ./utils
    ./extra
  ];

  programs.nixvim = {
    enable = true;

    enableMan = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withRuby = true;
  };

  programs.zsh.shellAliases = {
    "v" = "nvim";
  };
}
