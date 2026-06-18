{
  flake.modules.nixos.network = {
    networking.networkmanager.enable = true;
    users.commonExtraGroups = [ "networkmanager" ];
  };
}
