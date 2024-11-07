{
  pkgs,
  lib,
  ...
}: let
  username = "fr4nk1in";
  maple-mono = pkgs.callPackage ../packages/fonts/maple-mono.nix {};
in {
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  # Password is needed when using sudo
  security.sudo.wheelNeedsPassword = true;

  # Nix garbage collection
  nix.gc.dates = lib.mkDefault "weekly";

  # Increase the amount of inotify watchers
  # Note that inotify watches consume 1kB on 64-bit machines.
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 1048576; # default:  8192
    "fs.inotify.max_user_instances" = 1024; # default:   128
    "fs.inotify.max_queued_events" = 1048576; # default: 16384
  };

  # Locale setting
  i18n.defaultLocale = "zh_CN.UTF-8";

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
            <string>cv98 off</string>
            <string>ss03 on</string>
          </edit>
        </match>
      '';
    };
  };

  # Docker
  # after rebuild remember to generate the cdi spec,
  # with pkgs.nvidia-docker installed:
  # $ sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
  # $ nvidia-ctk cdi generate --output=/home/${username}/.cdi/nvidia.yaml
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        features.cdi = true;
        cdi-spec-dirs = ["/home/${username}/.cdi"];
      };
    };
    daemon.settings = {
      features.cdi = true;
    };
  };
  hardware = {
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = false;
      open = false;
    };
    nvidia-container-toolkit.enable = true;
  };
  services.xserver.videoDrivers = ["nvidia"];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };

    starship = {
      enable = true;
    };

    nix-ld.dev.enable = true;
  };
}
