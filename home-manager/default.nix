{
  config,
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

      neovimType = lib.mkOption {
        type = lib.types.enum ["full" "minimal"];
        default = "full";
        description = "The nixvim configuration";
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
        if cfg.system == "darwin"
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
    };

    # Let Home Manager install and manage itself.
    programs = {home-manager.enable = true;} // cfg.extraProgramConfig;
  };
}
