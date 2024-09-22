{
  pkgs,
  lib,
  ...
}: let
  maple-mono = pkgs.callPackage ../fonts/maple-mono.nix {};
in {
  # Default user
  users.users = {
    fushen = {
      isNormalUser = true;
      description = "Shen Fu";
      extraGroups = ["wheel"];
    };
  };

  nix.settings = {
    trusted-users = ["fushen"];

    # Enable flakes globally
    experimental-features = ["nix-command" "flakes"];

    # Cache mirror located in China
    substituters = [
      # status: https://mirrors.ustc.edu.cn/status
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      # status: https://mirror.sjtu.edu.cn/
      "https://mirror.sjtu.edu.cn/nix-channels/store"

      # nix community's cache server
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      # nix community's cache server public key
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Password is needed when using sudo
  security.sudo.wheelNeedsPassword = true;

  # Locale setting
  i18n.defaultLocale = "zh_CN.UTF-8";
  time.timeZone = "Asia/Shanghai";

  # Garbage collection
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Increase the amount of inotify watchers
  # Note that inotify watches consume 1kB on 64-bit machines.
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 1048576; # default:  8192
    "fs.inotify.max_user_instances" = 1024; # default:   128
    "fs.inotify.max_queued_events" = 1048576; # default: 16384
  };

  # Basic packages to maintain a minimal usable shell
  environment.systemPackages = with pkgs; [
    git
    vim
    neovim
    wget
    curl
  ];

  # Setting default editor to vim
  environment.variables.EDITOR = "nvim";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.starship = {
    enable = true;
  };

  # Fonts
  fonts = {
    packages = [
      pkgs.inter # sans-serif
      pkgs.source-han-sans # sans-serif for CJK
      pkgs.source-han-serif # serif
      pkgs.noto-fonts-color-emoji # emoji
      maple-mono # monospace
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = ["Inter Display" "Source Han Sans SC"];
        serif = ["Source Han Serif SC"];
        monospace = ["Maple Mono NF CN"];
      };
      localConf = ''
        <match target="font">
          <test name="family" compare="eq" ignore-blanks="true">
            <string>Maple Mono NF CN</string>
          </test>
          <edit name="fontfeatures" mode="assign_replace">
            <string>locl off</string>
            <string>cv01 on</string>
            <string>cv03 on</string>
            <string>ss03 on</string>
          </edit>
        </match>
      '';
    };
  };

  # Docker
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        registry-mirrors = [
          "https://docker.mirrors.ustc.edu.cn"
          "http://hub-mirror.c.163.com"
          "https://registry.docker-cn.com"
        ];
      };
    };
    daemon.settings = {
      registry-mirrors = [
        "https://docker.mirrors.ustc.edu.cn"
        "http://hub-mirror.c.163.com"
        "https://registry.docker-cn.com"
      ];
    };
  };
}
