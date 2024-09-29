{lib, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;
    enableSyntaxHighlighting = true;
  };

  nix.gc.interval = lib.mkDefault {
    Weekday = 7;
  };

  services.nix-daemon.enable = true;

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
      "microsoft-office"
      "clash-verge-rev"
      "bitwarden"
    ];
    caskArgs = {
      language = "zh-CN";
    };
    onActivation = {
      cleanup = "zap";
    };
  };
}
