{
  flake.modules.homeManager.desktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.vicinae = lib.optionalAttrs pkgs.stdenv.isLinux {
        enable = true;
        systemd.enable = true;

        settings = {
          close_on_focus_loss = true;
          favicon_service = "twenty";
          pop_to_root_on_close = true;
          search_files_in_root = true;

          font.normal = {
            family = "Monospace";
            size = config.stylix.fonts.sizes.terminal;
          };

          launcher_window = {
            client_side_decoration = {
              enabled = true;
              rounding = 10;
            };
            blur.enabled = true;
          };

          layer_shell.enabled = true;

          consider_preedit = true;
        };
      };
    };
}
