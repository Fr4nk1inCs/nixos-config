{
  config,
  pkgs,
  ...
}: {
  programs.neovide = {
    inherit (config.homeManagerConfig.gui) enable;
    settings = {
      frame =
        if pkgs.stdenv.isDarwin
        then "transparent"
        else "normal";
      font = {
        features."Maple Mono NF CN" = [
          "+calt"
          "-zero"
          "+cv01"
          "-cv02"
          "+cv03"
          "-cv04"
          "-cv98"
          "-cv99"
          "-ss01"
          "+ss03"
        ];
      };
    };
  };
}
