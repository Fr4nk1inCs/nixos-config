_: {
  flake.modules.homeManager.agents =
    { config, lib, ... }:
    let
      cfg = config.stylix.targets.kimi-code;
      colors = config.lib.stylix.colors;

      mkVariantColor =
        light: dark: if config.stylix.polarity == "light" then light else dark;
    in
    {
      options.stylix.targets.kimi-code = {
        enable = lib.mkEnableOption "theming for Kimi Code" // {
          default = config.stylix.autoEnable;
        };
      };

      config = lib.mkIf (config.stylix.enable && cfg.enable) {
        programs.kimi-code = {
          tui.theme = "stylix";

          # Token reference:
          # https://www.kimi.com/code/docs/en/kimi-code-cli/customization/themes.html
          themes.stylix = {
            name = "stylix";
            displayName = "Stylix";
            base = config.stylix.polarity;

            colors = with colors.withHashtag; {
              primary = mkVariantColor base0F base0D;
              accent = base0E;

              text = base05;
              textStrong = base06;
              textDim = base04;
              textMuted = base03;

              border = mkVariantColor base03 base02;
              borderFocus = base0A;

              success = base0B;
              warning = base0A;
              error = base08;

              diffAdded = base0B;
              diffRemoved = base08;
              diffAddedStrong = base0B;
              diffRemovedStrong = base08;
              diffGutter = base03;
              diffMeta = base04;

              roleUser = base09;
              shellMode = base0E;
            };
          };
        };
      };
    };
}
