{pkgs, ...}: {
  imports = [
    ../default.nix
  ];

  homeManagerConfig = {
    username = "sf";
    nixvimConfig.type = "minimal";
    extraPackages = with pkgs; [mihomo];
    extraProgramConfig.zsh.initExtra = ''
      # added by Nix installer
      if [ -e /home/sf/.nix-profile/etc/profile.d/nix.sh ]; then
        . /home/sf/.nix-profile/etc/profile.d/nix.sh;
      fi
    '';
  };
}
