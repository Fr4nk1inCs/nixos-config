{
  inputs,
  ...
}:
{
  flake.modules = {
    nixos.system-default = {
      imports = with inputs.self.modules.nixos; [
        system-minimal
        # tools
        home-manager
        agenix
        nh
        nix-ld
        stylix
        # system settings
        network
        locale
        container
        inotify
      ];
    };

    darwin.system-default = {
      imports = with inputs.self.modules.darwin; [
        system-minimal
        # tools
        home-manager
        agenix
        homebrew
        # system settings
        locale
        container
      ];
    };

    homeManager.system-default = {
      imports = with inputs.self.modules.homeManager; [
        system-minimal
        agenix
        nh
        stylix
      ];
    };
  };
}
