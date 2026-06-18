{ inputs, ... }: {
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.modules =
    let
      common-home-manager-config.home-manager = {
        verbose = true;
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
      };
    in
    {
      nixos.home-manager = {
        imports = [
          inputs.home-manager.nixosModules.home-manager
          common-home-manager-config
        ];
      };

      darwin.home-manager = {
        imports = [
          inputs.home-manager.darwinModules.home-manager
          common-home-manager-config
        ];
      };
    };
}
