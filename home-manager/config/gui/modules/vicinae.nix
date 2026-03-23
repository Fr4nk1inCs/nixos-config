{
  config,
  pkgs,
  lib,
  ...
}: let
  enable = config.profile.windowManager.enable && pkgs.stdenv.isLinux;
in {
  config.programs.vicinae = {
    inherit enable;

    systemd.enable = enable;

    settings = {
      close_on_focus_loss = true;
      favicon_service = "twenty";
      pop_to_root_on_close = true;
      search_files_in_root = true;

      font.normal = {
        family = "monospace";
        size = config.stylix.fonts.sizes.terminal;
      };

      launcher_window = {
        client_side_decoration = {
          enabled = true;
          rounding = 10;
        };
        blur.enabled = true;
        opacity = lib.mkForce config.stylix.opacity.applications;
      };

      layer_shell.enabled = true;
    };
  };
}
