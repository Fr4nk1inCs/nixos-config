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

  stylix = {
    enable = true;

    autoEnable = true;
    overlays.enable = false;

    base16Scheme = {
      # nordfox
      system = "base24";
      name = "Nordfox";
      slug = "nordfox";
      description = "Nordfox palette from EdenEast/nightfox.nvim";
      variant = "dark";

      base00 = "#2e3440";
      base01 = "#39404f";
      base02 = "#444c5e";
      base03 = "#465780";
      base04 = "#7e8188";
      base05 = "#cdcecf";
      base06 = "#abb1bb";
      base07 = "#e7ecf4";
      base08 = "#bf616a";
      base09 = "#c9826b";
      base0A = "#ebcb8b";
      base0B = "#a3be8c";
      base0C = "#88c0d0";
      base0D = "#81a1c1";
      base0E = "#b48ead";
      base0F = "#bf88bc";
      base10 = "#232831";
      # base11 = "";
      base12 = "#d06f79";
      base13 = "#f0d399";
      base14 = "#b1d196";
      base15 = "#93ccdc";
      base16 = "#8cafd2";
      base17 = "#c895bf";
    };

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
