{
  lib,
  pkgs,
  ...
}: {
  # imports = [
  #   ./sketchybar.nix
  # ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
  };

  nix.gc.interval = lib.mkDefault {
    Weekday = 7;
  };

  services.nix-daemon.enable = true;

  # Nix-Darwin configurations
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      AppleShowScrollBars = "Automatic";
      AppleTemperatureUnit = "Celsius";
      AppleEnableMouseSwipeNavigateWithScrolls = true;
      AppleEnableSwipeNavigateWithScrolls = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticWindowAnimationsEnabled = false;
      NSTextShowsControlCharacters = true;
      NSWindowShouldDragOnGesture = true;
      "com.apple.keyboard.fnState" = true;
    };
    dock.orientation = "left";
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
    };
    menuExtraClock = {
      Show24Hour = true;
      ShowDate = 0;
      ShowDayOfMonth = true;
      ShowDayOfWeek = true;
    };
    trackpad.TrackpadThreeFingerDrag = true;
    CustomUserPreferences = {
      "com.apple.controlcenter" = {
        Bluetooth = 18;
        BatteryShowPercentage = true;
      };
    };
  };

  # Homebrew for softwares not available in Nixpkgs
  environment.variables = {
    HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.ustc.edu.cn/brew.git";
    HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.ustc.edu.cn/homebrew-core.git";
    HOMEBREW_BOTTLE_DOMAIN = "https://mirrors.ustc.edu.cn/homebrew-bottles";
    HOMEBREW_API_DOMAIN = "https://mirrors.ustc.edu.cn/homebrew-bottles/api";
  };
  homebrew = {
    enable = true;
    brews = [
    ];
    casks = [
      "qq"
      "wechat"
      # "microsoft-office" # use institutional license instead
      "clash-verge-rev"
      "bitwarden"
      "zotero"
      "logi-options+"
      "fliqlo"
    ];
    caskArgs = {
      language = "zh-CN";
    };
    onActivation = {
      cleanup = "zap";
    };
  };
}
