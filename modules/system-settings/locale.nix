{
  flake.modules = {
    nixos.locale = {
      i18n.defaultLocale = "zh_CN.UTF-8";
      time.timeZone = "Asia/Shanghai";
    };

    darwin.locale = {
      homebrew.caskArgs.language = "zh-CN";
      time.timeZone = "Asia/Shanghai";

      system.defaults = {
        NSGlobalDomain = {
          AppleICUForce24HourTime = true;
          AppleMeasurementUnits = "Centimeters";
          AppleMetricUnits = 1;
          AppleTemperatureUnit = "Celsius";
        };
      };
    };
  };
}
