{
  flake.modules = {
    nixos.container = {
      users.commonExtraGroups = [ "docker" ];
      virtualisation = {
        docker = {
          enable = true;
          rootless = {
            enable = true;
            setSocketVariable = true;
          };
        };
      };
    };

    darwin.container = {
      homebrew.casks = [ "orbstack" ];
    };
  };
}
