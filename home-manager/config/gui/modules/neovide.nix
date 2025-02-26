{
  config,
  pkgs,
  ...
}: let
in {
  programs.neovide = {
    inherit (config.homeManagerConfig.gui) enable;
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
