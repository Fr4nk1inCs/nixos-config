{...}: {
  imports = [
    ../../modules/system
    ../../modules/system/darwin.nix
  ];

  networking.computerName = "Fr4nk1in's MacBook Air";
  networking.hostName = "fr4nk1in-macbook-air";

  system.stateVersion = 5;
}
