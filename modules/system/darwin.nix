{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
  };

  nix.gc.interval = lib.mkDefault {
    Weekday = 7;
  };

  # services.sketchybar.enable = true;
  # services.skhd = {
  #   enable = true;
  #   skhdConfig = ''
  #     alt - return : kitty --directory ~
  #   '';
  # };

  launchd.user.agents.sketchybar.serviceConfig = {
    StandardErrorPath = "/tmp/sketchybar.error.log";
    StandardOutPath = "/tmp/sketchybar.out.log";
  };
  launchd.user.agents.skhd.serviceConfig = {
    StandardErrorPath = "/tmp/skhd.error.log";
    StandardOutPath = "/tmp/skhd.out.log";
  };

  # Nix-Darwin configurations
  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    NSGlobalDomain = {
      AppleEnableMouseSwipeNavigateWithScrolls = true;
      AppleEnableSwipeNavigateWithScrolls = true;
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      AppleShowScrollBars = "Automatic";
      AppleTemperatureUnit = "Celsius";
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticWindowAnimationsEnabled = false;
      NSTextShowsControlCharacters = true;
      NSWindowShouldDragOnGesture = true;

      "com.apple.keyboard.fnState" = true;
    };
    dock = {
      orientation = "left";
      autohide = true;
      mru-spaces = false;
      persistent-apps = [
        "/System/Applications/Launchpad.app"
        "${pkgs.kitty}/Applications/Kitty.app"
        "/Applications/Arc.app"
        "/Applications/QQ.app"
        "/Applications/WeChat.app"
        "/System/Applications/Mail.app"
        "/Applications/Notion.app"
        "/Applications/Zotero.app"
        "/System/Applications/Music.app"
        "/System/Applications/System Settings.app"
      ];
    };
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
        Battery = 9;
        BatteryShowPercentage = true;
      };

      # "com.apple.inputsources" = {
      #   AppleEnabledThirdPartyInputSources = [
      #     {
      #       "Bundle ID" = "com.sogou.inputmethod.sogou";
      #       InputSourceKind = "Keyboard Input Method";
      #     }
      #   ];
      # };

      "com.apple.inputmethod.CoreChineseEnigneFramework" = {
        candidateWindowDirection = 0;
        fontSize = 14;
        usesHalfwidthPunctuation = 1;
      };
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  # Homebrew for softwares not available in Nixpkgs
  environment.variables = {
    HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.ustc.edu.cn/brew.git";
    HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.ustc.edu.cn/homebrew-core.git";
    HOMEBREW_BOTTLE_DOMAIN = "https://mirrors.ustc.edu.cn/homebrew-bottles";
    HOMEBREW_API_DOMAIN = "https://mirrors.ustc.edu.cn/homebrew-bottles/api";
  };
  environment.systemPackages = with pkgs; [
    # terminal
    kitty
    # browser
    google-chrome
    # instant messaging
    telegram-desktop
    # remote code editing
    vscode
    # app launcher
    raycast
    # menubar utility
    ice-bar
    stats
    # battery management
    aldente
    # pdf reader
    skimpdf
    # input method
    sogou-pinyin
    # video player
    iina
    # google drive
    gdrive3
  ];
  homebrew = {
    enable = true;
    brews = [
    ];
    casks = [
      "arc"
      "betterdisplay"
      "bitwarden"
      "clash-verge-rev"
      "dingtalk"
      "fliqlo"
      "follow"
      "ghostty"
      "google-drive"
      "jetbrains-toolbox"
      "logi-options+"
      # "microsoft-office" # use institutional license instead
      "moonlight"
      "motrix"
      "notion"
      "obsidian"
      "orbstack"
      "parsec"
      "qq"
      "steam"
      "tencent-meeting"
      "tomatobar"
      "wechat"
      "zerotier-one"
      "zoom"
      "zotero"
    ];
    masApps = {
      Notability = 360593530;
      Goodnotes = 1444383602;
      XCode = 497799835;
    };
    caskArgs = {
      language = "zh-CN";
    };
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
