{ self, ... }: {
  flake.modules.darwin.desktop = {
    system = {
      defaults = {
        NSGlobalDomain = {
          NSAutomaticWindowAnimationsEnabled = false;
          NSTextShowsControlCharacters = true;
          AppleShowScrollBars = "Automatic";
        };
      };
    };
  };

  flake.modules.homeManager.desktop = { pkgs, lib, ... }: {
    home.packages =
      lib.optionals pkgs.stdenv.isLinux [
        pkgs.baobab
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        pkgs.betterdisplay
        pkgs.aldente
      ];

    stylix = {
      targets.gtk.enable = pkgs.stdenv.isLinux;

      image = self.lib.getAsset "rick-4k.png";

      opacity = {
        applications = 0.95;
        desktop = 0.95;
        terminal = 0.8;
      };
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      cursor = {
        name = "WhiteSur-cursors";
        package = pkgs.whitesur-cursors;
        size = 24;
      };

      icons = {
        enable = true;
        package = pkgs.whitesur-icon-theme.override {
          themeVariants = [ "nord" ];
        };
        dark = "WhiteSur-nord-dark";
        light = "WhiteSur-nord-light";
      };
    };
  };
}
