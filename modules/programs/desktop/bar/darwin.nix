{
  flake.modules.darwin.desktop = {
    homebrew.casks = [
      "thaw"
      "tomatobar"
    ];

    system.defaults = {
      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 0;
        ShowDayOfMonth = true;
        ShowDayOfWeek = true;
      };
      CustomUserPreferences = {
        "com.apple.controlcenter" = {
          # 9 - Hide, 18 - Always Show
          Bluetooth = 18;
          Display = 9;
          Sound = 9;

          Battery = 9;
          BatteryShowPercentage = true;
        };
      };
    };
  };

  flake.modules.homeManager.desktop = { pkgs, lib, ... }: {
    home.packages = lib.optional pkgs.stdenv.isDarwin pkgs.stats;
  };
}
