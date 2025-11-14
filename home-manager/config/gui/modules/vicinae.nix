{
  config,
  pkgs,
  ...
}: let
  enable = config.profile.windowManager.enable && pkgs.stdenv.isLinux;
in {
  config.programs.vicinae = {
    inherit enable;
    systemd.enable = false;

    settings = {
      closeOnFocusLoss = true;
      faviconService = "twenty";
      font = {
        normal = config.stylix.fonts.monospace.name;
        size = config.stylix.fonts.sizes.applications;
      };
      theme = {
        iconTheme = config.stylix.icons.dark;
        name = "nordfox";
      };
      keybinding = "default";
      popToRootOnClose = true;
      rootSearch.searchFiles = true;
      window = {
        csd = true;
        opacity = config.stylix.opacity.applications;
        rounding = 10;
      };
    };

    themes = {
      nordfox = {
        meta = {
          version = 1;
          name = "nordfox";
          description = "Nordfox theme based on EdenEast/nightfox.nvim";
          variant = "dark";
          inherits = "nord";
        };

        colors = with config.lib.stylix.colors.withHashtag; {
          core = {
            background = base00;
            foreground = base05;
            secondary_background = base10;
            border = base02;
            accent = blue;
          };
          accents = {
            inherit blue cyan green magenta orange red yellow;
            purple = brown; # mapped to base0F
          };
        };
      };
    };
  };
}
