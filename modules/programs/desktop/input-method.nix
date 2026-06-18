{
  flake.modules.nixos.desktop = {
    # TODO: IME in NixOS
  };

  flake.modules.darwin.desktop = {
    system.defaults.CustomUserPreferences = {
      "com.apple.inputmethod.CoreChineseEnigneFramework" = {
        candidateWindowDirection = 0;
        fontSize = 14;
        usesHalfwidthPunctuation = 1;
      };
    };
  };
}
