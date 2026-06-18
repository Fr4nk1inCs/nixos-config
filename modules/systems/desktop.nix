{
  inputs,
  lib,
  ...
}:
{
  options.flake.windowManager = {
    modKey = lib.mkOption {
      type = lib.types.enum [
        "Super"
        "Alt"
      ];
      default = "Super";
      description = "The modifier key for the window manager";
    };

    nestedModKey = lib.mkOption {
      type = lib.types.enum [
        "Super"
        "Alt"
      ];
      default = "Alt";
      description = "The modifier key for nested window manager applications";
    };

    bar = {
      battery.enable = lib.mkEnableOption "Enable battery status on the bar";
      temperature.enable = lib.mkEnableOption "Enable temperature status on the bar";
      backlight.enable = lib.mkEnableOption "Enable backlight status on the bar";
    };
  };

  config.flake.modules = {
    nixos.system-desktop = {
      imports = with inputs.self.modules.nixos; [
        system-cli

        fonts

        desktop
      ];

      services.xserver.enable = true;

      environment.pathsToLink = [
        "/share/applications"
        "/share/xdg-desktop-protocol"
      ];
    };

    darwin.system-desktop = {
      imports = with inputs.self.modules.darwin; [
        system-cli

        fonts
        io

        desktop
      ];
    };

    homeManager.system-desktop = {
      imports = with inputs.self.modules.homeManager; [
        system-cli

        fonts

        desktop
      ];
    };
  };
}
