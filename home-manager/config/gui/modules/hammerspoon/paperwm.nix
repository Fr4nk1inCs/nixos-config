{
  pkgs,
  lib,
  config,
  ...
}: let
  enable = pkgs.stdenv.isDarwin && config.profile.windowManager.enable;
  spoons = "hammerspoon/Spoons";
in {
  config.xdg.configFile = lib.mkIf enable {
    "hammerspoon/init.lua".text = lib.mkAfter (builtins.readFile ./paperwm.lua);

    "${spoons}/PaperWM.spoon".source = pkgs.fetchFromGitHub {
      owner = "mogenson";
      repo = "PaperWM.spoon";
      rev = "254bf9244e316e231cd9d37e9a03ad147314bbee";
      sha256 = "1z7pfqicmrkn0r0fa6m1g7v6yk6hp4ip30rghsbghcljsz05a687";
    };
    "${spoons}/WarpMouse.spoon".source = pkgs.fetchFromGitHub {
      owner = "mogenson";
      repo = "WarpMouse.spoon";
      rev = "c7f51d07aba13884648f05d116a0074e08f2e644";
      sha256 = "0f40j7a6p0y1dc8rnj39lbgfyfjg5v2zjliphyp2yxna6jbacmdi";
    };
  };
}
