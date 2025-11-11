{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.homeManagerConfig;
in {
  options = {
    homeManagerConfig = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "fr4nk1in";
        description = "The username";
      };

      gui = {
        enable = lib.mkEnableOption "Enable GUI programs";
        software.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          example = false;
          description = "Enable GUI softwares";
        };
        mod-key = lib.mkOption {
          type = lib.types.enum ["Super" "Alt"];
          default = "Super";
          description = "The modifier key for GUI applications";
        };
        mod-key-nested = lib.mkOption {
          type = lib.types.enum ["Super" "Alt"];
          default = "Alt";
          description = "The modifier key for nested GUI applications";
        };
      };

      hasBattery = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the device has a battery";
      };

      neovimType = lib.mkOption {
        type = lib.types.enum ["full" "minimal"];
        default = "full";
        description = "The nixCats-nvim configuration";
      };

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "A list of extra packages to install";
      };

      extraProgramConfig = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Extra program configuration";
      };
    };
  };

  imports = [
    ./config
    ./age.nix
  ];

  config = {
    home = {
      inherit (cfg) username;
      homeDirectory = lib.mkForce (
        if pkgs.stdenv.isDarwin
        then "/Users/${cfg.username}"
        else "/home/${cfg.username}"
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

      packages = cfg.extraPackages;

      preferXdgDirectories = true;
    };

    # Let Home Manager install and manage itself.
    programs = {home-manager.enable = true;} // cfg.extraProgramConfig;
  };
}
