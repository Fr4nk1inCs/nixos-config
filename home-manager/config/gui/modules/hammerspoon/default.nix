{
  pkgs,
  lib,
  ...
}: let
  enableHammerspoon = pkgs.stdenv.isDarwin;
  spoons = "hammerspoon/Spoons";
in {
  imports = [./paperwm.nix];

  config = lib.mkIf enableHammerspoon {
    # check modules/system/darwin.nix for the path
    xdg.configFile = {
      "hammerspoon/init.lua".text = builtins.readFile ./init-base.lua;

      "${spoons}/ReloadConfiguration.spoon".source = let
        rev = "e5b871250346c3fe93bac0d431fc75f6f0e2f92a";
      in
        pkgs.fetchzip {
          url = "https://github.com/Hammerspoon/Spoons/raw/${rev}/Spoons/ReloadConfiguration.spoon.zip";
          sha256 = "0bg8fdzg2w4zl4fkxkfppd73ckgbky3xh2wlhlayxm72zlf8bp4h";
        };
    };
  };
}
