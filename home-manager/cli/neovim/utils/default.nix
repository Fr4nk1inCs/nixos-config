{...}: {
  imports = [
    ./ui.nix
    ./test.nix
  ];

  programs.nixvim.extraConfigLuaPre = "local utils = {}";
}
