{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    profile = {
      neovimPackage = lib.mkOption {
        type = lib.types.enum ["nvim" "minivim"];
        default = "nvim";
        description = "The Neovim package to use";
      };

      guiSoftwares.enable = lib.mkEnableOption "Enable GUI softwares";

      windowManager = {
        enable = lib.mkEnableOption "Enable window manager configuration";

        modKey = lib.mkOption {
          type = lib.types.enum ["Super" "Alt"];
          default = "Super";
          description = "The modifier key for the window manager";
        };

        nestedModKey = lib.mkOption {
          type = lib.types.enum ["Super" "Alt"];
          default = "Alt";
          description = "The modifier key for nested window manager applications";
        };

        bar = {
          battery.enable = lib.mkEnableOption "Enable battery status on the bar";
          temperature.enable = lib.mkEnableOption "Enable temperature status on the bar";
          backlight.enable = lib.mkEnableOption "Enable backlight status on the bar";
        };
      };
    };
  };

  imports = [
    ./config
    ./age.nix
  ];

  config = {
    home = {
      homeDirectory = lib.mkForce (
        if pkgs.stdenv.isDarwin
        then "/Users/${config.home.username}"
        else "/home/${config.home.username}"
      );

      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      stateVersion = "24.05";

      preferXdgDirectories = true;
    };

    # Let Home Manager install and manage itself.
    programs = {home-manager.enable = true;};
  };
}
