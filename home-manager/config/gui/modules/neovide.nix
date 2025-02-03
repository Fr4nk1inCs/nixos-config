{
  config,
  pkgs,
  ...
}: let
  inherit (config.homeManagerConfig.gui) enable;
in {
  programs.neovide = {
    inherit enable;
    settings = {
      frame =
        if pkgs.stdenv.isDarwin
        then "transparent"
        else "normal";
      font = {
        normal = "Maple Mono NF CN";
        size = 11.5;

        features."Maple Mono NF CN" = [
          "-zero"
          "+cv01"
          "-cv02"
          "+cv03"
          "-cv04"
          "-cv98"
          "-cv99"
          "-ss01"
        ];
      };
    };
  };
}
