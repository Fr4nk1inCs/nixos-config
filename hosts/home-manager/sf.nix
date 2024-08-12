{pkgs, ...}: {
  imports = [
    ../../home-manager
  ];

  homeManagerConfig = {
    username = "sf";
    nixvimConfig.type = "minimal";
    extraPackages = with pkgs; [mihomo];
    extraProgramConfig = ''
      # added by Nix installer
      if [ -e /home/sf/.nix-profile/etc/profile.d/nix.sh ]; then
        . /home/sf/.nix-profile/etc/profile.d/nix.sh;
      fi
    '';
  };
}
