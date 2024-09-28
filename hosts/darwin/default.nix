{...}: {
  imports = [
    ../../modules/system
    ../../modules/system/darwin.nix
  ];

  networking.hostName = "fushen-mac"; # Define your hostname

  system.stateVersion = 5;
}
