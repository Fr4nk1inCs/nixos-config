{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
    ./linux.nix
    ./darwin.nix
  ];

  stylix = let
    scheme = (import ./schemes.nix).nord-light;
  in {
    enable = true;

    autoEnable = true;
    overlays.enable = false;

    polarity = scheme.variant;
    base16Scheme = scheme;

    targets.fontconfig.enable = false;

    fonts = {
      monospace = {
        name = "Maple Mono NF CN";
        package = pkgs.maple-mono.NF-CN;
      };

      sizes = {
        terminal = 12;
      };
    };

    opacity = {
      applications = 0.95;
      desktop = 0.95;
      terminal = 0.8;
    };
  };
}
