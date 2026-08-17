{
  flake.modules.darwin.homebrew = {
    environment.variables = {
      HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.ustc.edu.cn/brew.git";
      HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.ustc.edu.cn/homebrew-core.git";
      HOMEBREW_BOTTLE_DOMAIN = "https://mirrors.ustc.edu.cn/homebrew-bottles";
      HOMEBREW_API_DOMAIN = "https://mirrors.ustc.edu.cn/homebrew-bottles/api";
    };

    programs.mas = {
      enable = true;
      cleanup = true;
    };

    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
        autoUpdate = true;
        upgrade = true;
      };
      masApps = {
        TestFlight = 899247664;
      };
    };
  };
}
