_: {
  flake.modules.nixos.system-minimal = { lib, ... }: {
    options = {
      users.commonExtraGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Additional groups to add all users to";
      };
    };

    config = {
      system.stateVersion = "24.05";
    };
  };
}
