{
  flake.modules.darwin.nvidia = {
    homebrew.casks = [
      "nvidia-nsight-systems"
    ];
  };

  flake.modules.nixos.nvidia = { pkgs, ... }: {
    hardware = {
      nvidia = {
        nvidiaSettings = false;
        open = true;
      };
      nvidia-container-toolkit.enable = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    environment.systemPackages = with pkgs; [
      cudaPackages.nsight_systems
      cudaPackages.nsight_compute

      nvidia-container-toolkit
      libnvidia-container
    ];
  };
}
