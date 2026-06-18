{ inputs, ... }:
{
  flake.modules.nixos.wsl = { lib, pkgs, ... }: {
    imports = [
      inputs.nixos-wsl.nixosModules.wsl

      inputs.self.modules.nixos.system-desktop
      inputs.self.modules.nixos.nvidia
    ];

    networking.hostName = "wsl";
    networking.networkmanager.enable = lib.mkForce false;

    # This is a temporary workaround for WSL
    # See issues:
    # - https://github.com/nix-community/NixOS-WSL/issues/171
    # - https://github.com/microsoft/WSL/issues/9213
    users.defaultUserShell =
      let
        wrapper = pkgs.writeShellScriptBin "shell-wrapper" ''
          . /etc/set-environment
          exec ${pkgs.zsh}/bin/zsh "$@"
        '';
      in
      lib.mkForce "${wrapper}/bin/shell-wrapper";

    wsl = {
      enable = true;
      interop.includePath = false;
      useWindowsDriver = true;
      startMenuLaunchers = true;
    };

    environment.variables = {
      LD_LIBRARY_PATH = "/usr/lib/wsl/lib/";
      # WSL exposes the GPU as /dev/dxg, not a DRM node under /dev/dri, so
      # Mesa's auto-loader finds no device and falls back to llvmpipe (software).
      # d3d12 is the gallium driver that targets /dev/dxg, so name it explicitly.
      GALLIUM_DRIVER = "d3d12";
    };

    environment.systemPackages = with pkgs; [
      wezterm
    ];

    services = {
      openssh.ports = lib.mkForce [ 2223 ];
      tailscale.port = 41642;
    };

    # NVIDIA Container on NixOS WSL
    systemd.services.nvidia-container-toolkit-cdi-generator.serviceConfig =
      let
        nvidia-ctk = lib.getExe' pkgs.nvidia-container-toolkit "nvidia-ctk";
        nvidia-cdi-hook = lib.getExe' (lib.getOutput "tools" pkgs.nvidia-container-toolkit) "nvidia-cdi-hook";
      in
      {
        ExecStart = lib.mkForce ''
          ${nvidia-ctk} cdi generate \
          --output=/var/run/cdi/nvidia-container-toolkit.json \
          --nvidia-cdi-hook-path=${nvidia-cdi-hook}
        '';
      };

    hardware.nvidia-container-toolkit.mount-nvidia-executables = false;

    # The NVIDIA driver is provided by the Windows host via NixOS-WSL
    # (wsl.useWindowsDriver), so the toolkit's driver assertion does not apply.
    hardware.nvidia-container-toolkit.suppressNvidiaDriverAssertion = true;
  };
}
