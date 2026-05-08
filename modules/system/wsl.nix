{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  # This is a temporary workaround for WSL
  # See issues:
  # - https://github.com/nix-community/NixOS-WSL/issues/171
  # - https://github.com/microsoft/WSL/issues/9213
  users.defaultUserShell = let
    wrapper = pkgs.writeShellScriptBin "shell-wrapper" ''
      . /etc/set-environment
      exec ${pkgs.zsh}/bin/zsh "$@"
    '';
  in
    lib.mkForce "${wrapper}/bin/shell-wrapper";

  # CUDA support
  environment.variables = {
    LD_LIBRARY_PATH = "/usr/lib/wsl/lib/";
  };

  environment.systemPackages = with pkgs; [
    wezterm
  ];

  services.openssh.ports = lib.mkForce [2223];
  services.tailscale.port = 41642;

  # NVIDIA Container on NixOS WSL
  systemd.services.nvidia-container-toolkit-cdi-generator.serviceConfig = let
    nvidia-ctk = lib.getExe' pkgs.nvidia-container-toolkit "nvidia-ctk";
    nvidia-cdi-hook = lib.getExe' (lib.getOutput "tools" pkgs.nvidia-container-toolkit) "nvidia-cdi-hook";
  in {
    ExecStart = lib.mkForce ''
      ${nvidia-ctk} cdi generate \
      --output=/var/run/cdi/nvidia-container-toolkit.json \
      --nvidia-cdi-hook-path=${nvidia-cdi-hook}
    '';
  };

  hardware.nvidia-container-toolkit.mount-nvidia-executables = false;
}
