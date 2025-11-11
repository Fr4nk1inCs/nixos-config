{
  pkgs,
  lib,
  ...
}: {
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

  services.openssh = {
    ports = lib.mkForce [2223];
  };

  programs.niri.enable = true;

  hardware.nvidia-container-toolkit.mount-nvidia-executables = false;
}
