{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homeManagerConfig;
in {
  options = {
    homeManagerConfig = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "fushen";
        description = "The username";
      };

      system = lib.mkOption {
        type = lib.types.enum ["linux" "darwin" "wsl"];
        default = "linux";
        description = "The system type";
      };

      gui.enable = lib.mkEnableOption "Enable GUI programs";
      gui.software.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable GUI softwares";
      };

      nixvimConfig = {
        type = lib.mkOption {
          type = lib.types.enum ["full" "minimal"];
          default = "full";
          description = "The nixvim configuration";
        };
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
    ./cli
    ./gui
  ];

  config = {
    home.username = cfg.username;
    home.homeDirectory = "/home/${cfg.username}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "24.05";

    # Let Home Manager install and manage itself.
    programs = {home-manager.enable = true;} // cfg.extraProgramConfig;

    home.packages = cfg.extraPackages;
  };
}
