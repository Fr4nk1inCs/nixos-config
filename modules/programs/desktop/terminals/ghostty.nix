{ self, ... }: {
  flake.modules.homeManager.desktop =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      inherit (pkgs.stdenv) isDarwin;
    in
    {
      stylix.targets.ghostty.fonts.override = lib.optionalAttrs isDarwin {
        # Bypass stylix's dpi conversion here.
        sizes.terminal = config.stylix.fonts.sizes.terminal * 3.0 / 4.0;
      };

      programs.ghostty =
        let
          inherit (pkgs.stdenv) isDarwin;
          inherit (self.lib.fontFeatures) toHarfBuzz;
          mod = if isDarwin then "cmd" else "ctrl+shift";
        in
        {
          enable = true;
          package = if isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
          settings = {
            font-feature = toHarfBuzz self.constants.fontFeatures.maple-mono;

            adjust-cell-width = "5%";

            cursor-click-to-move = true;

            mouse-hide-while-typing = true;
            mouse-scroll-multiplier = 3;

            background-blur = 20;

            link-url = true;

            window-vsync = true;
            window-padding-balance = true;
            window-decoration = if pkgs.stdenv.isDarwin then "auto" else "none";
            macos-titlebar-style = "hidden";

            clipboard-read = "allow";
            clipboard-write = "allow";
            clipboard-trim-trailing-spaces = true;

            quick-terminal-position = "top";
            quick-terminal-screen = "mouse";
            quick-terminal-animation-duration = 0.2;
            quick-terminal-autohide = true;
            quick-terminal-space-behavior = "move";

            shell-integration-features = [
              "cursor"
              "sudo"
              "title"
              "ssh-terminfo"
            ];

            macos-option-as-alt = true;

            gtk-single-instance = true;

            bell-features = [
              "system"
              "no-audio"
              "no-attention"
            ];

            keybind = [
              "ctrl+enter=new_split:auto"
              "${mod}+t=new_tab"
              "${mod}+e=equalize_splits"
              "${mod}+h=goto_split:left"
              "${mod}+j=goto_split:down"
              "${mod}+k=goto_split:up"
              "${mod}+l=goto_split:right"
              "global:${mod}+enter=new_window"
              "global:${mod}+backslash=toggle_quick_terminal"
            ];
          };
        };
    };
}
