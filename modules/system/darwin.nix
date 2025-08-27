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

  nix.gc = {
    automatic = true;
    interval = lib.mkDefault {Weekday = 7;};
  };

  # services.sketchybar.enable = true;
  # services.skhd = {
  #   enable = true;
  #   skhdConfig = ''
  #     alt - return : kitty --directory ~
  #   '';
  # };

  # launchd.user.agents.sketchybar.serviceConfig = {
  #   StandardErrorPath = "/tmp/sketchybar.error.log";
  #   StandardOutPath = "/tmp/sketchybar.out.log";
  # };
  # launchd.user.agents.skhd.serviceConfig = {
  #   StandardErrorPath = "/tmp/skhd.error.log";
  #   StandardOutPath = "/tmp/skhd.out.log";
  # };

  # Nix-Darwin configurations
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    primaryUser = "fr4nk1in";

    defaults = {
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
          "/Applications/Ghostty.app"
          "/Applications/Arc.app"
          "/Applications/QQ.app"
          "/Applications/WeChat.app"
          "/System/Applications/Mail.app"
          "/Applications/Notion.app"
          "${pkgs.zotero}/Applications/Zotero.app"
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
          # 9 - Hide, 18 - Always Show
          Bluetooth = 18;
          Display = 9;
          Sound = 9;

          Battery = 9;
          BatteryShowPercentage = true;
        };

        "com.apple.inputmethod.CoreChineseEnigneFramework" = {
          candidateWindowDirection = 0;
          fontSize = 14;
          usesHalfwidthPunctuation = 1;
        };
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
  environment.systemPackages = with pkgs; [
    kitty
  ];

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
      "arc"
      "appflowy"
      "bitwarden"
      "clash-verge-rev"
      "dingtalk"
      "folo"
      "ghostty"
      "google-drive"
      "logi-options+"
      # "microsoft-office" # use institutional license instead
      "motrix"
      "notion"
      "obsidian"
      "orbstack"
      "qq"
      "teamspeak-client@beta"
      "tencent-meeting"
      "tomatobar"
      "wechat"
      "zerotier-one"
      "zoom"
    ];
    masApps = {
      Notability = 360593530;
      Goodnotes = 1444383602;
      Numbers = 409203825;
      # "Any Text" = 1643199620;
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
