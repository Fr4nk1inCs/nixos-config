{
  flake.modules.darwin.io = {
    homebrew.casks = [
      "logi-options+"
    ];

    system.defaults = {
      NSGlobalDomain = {
        AppleEnableMouseSwipeNavigateWithScrolls = true;
        AppleEnableSwipeNavigateWithScrolls = true;
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSWindowShouldDragOnGesture = true;

        "com.apple.keyboard.fnState" = true;
      };

      trackpad.TrackpadThreeFingerDrag = true;
    };

    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
