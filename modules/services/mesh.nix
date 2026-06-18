{
  flake.modules = {
    nixos.mesh = { pkgs, ... }: {
      services.tailscale = {
        enable = true;
        openFirewall = true;
        interfaceName = "Tailscale";
      };

      environment.systemPackages = with pkgs; [
        tailscale
      ];
    };

    darwin.mesh = {
      homebrew.casks = [ "tailscale-app" ];
    };
  };
}
