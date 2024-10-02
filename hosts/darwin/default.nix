{...}: {
  imports = [
    ../../modules/system
    ../../modules/system/darwin.nix
  ];

  networking.computerName = "Fu Shen's MacBook Air";
  networking.hostName = "fushen-macbook-air";

  system.stateVersion = 5;
}
