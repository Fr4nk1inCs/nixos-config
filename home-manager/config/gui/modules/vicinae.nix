{
  config,
  pkgs,
  ...
}: let
  enable = config.homeManagerConfig.gui.enable && pkgs.stdenv.isLinux;
in {
  services.vicinae = {
    inherit enable;
    autoStart = false;

    settings = {
      closeOnFocusLoss = true;
      faviconService = "twenty";
      font = {
        normal = config.stylix.fonts.monospace.name;
        size = config.stylix.fonts.sizes.applications;
      };
      theme = {
        iconTheme = config.stylix.icons.dark;
        name = "nord";
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
  };
}
