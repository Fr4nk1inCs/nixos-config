{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  username = "fr4nk1in";
in
{
  imports = [
    inputs.niri.nixosModules.niri
    inputs.nix-ld.nixosModules.nix-ld
    inputs.agenix.nixosModules.default
  ];

  age = {
    secrets.mihomo.file = ../../secrets/mihomo.age;
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
    ];
  };

  # networkmanager
  networking.networkmanager.enable = true;

  # Password is needed when using sudo
  security.sudo.wheelNeedsPassword = true;

  # Nix garbage collection
  nix.gc.dates = lib.mkDefault "weekly";

  # Increase the amount of `inotify` watchers
  # Note that `inotify` watches consume 1kB on 64-bit machines.
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 1048576; # default: 8192
    "fs.inotify.max_user_instances" = 1024; # default: 128
    "fs.inotify.max_queued_events" = 1048576; # default: 16384
  };

  # Locale setting
  i18n.defaultLocale = "zh_CN.UTF-8";

  # Fonts
  fonts = {
    packages = with pkgs; [
      fonts.misans.variable # sans-serif
      source-han-serif # serif
      noto-fonts-color-emoji # emoji
      maple-mono.NF-CN # monospace
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = [
          "SF Pro"
          "PingFang SC"
          "MiSans VF"
        ];
        serif = [
          "New York"
          "Songti SC"
          "Source Han Serif SC"
        ];
        monospace = [ "Maple Mono NF CN" ];
        emoji = [
          "Apple Color Emoji"
          "Noto Color Emoji"
        ];
      };
      localConf = ''
        <match target="font">
          <test name="family" compare="eq" ignore-blanks="true">
            <string>Maple Mono NF CN</string>
          </test>
          <edit name="fontfeatures" mode="assign_replace">
            <string>calt on</string>
            <string>cv01 on</string>
            <string>cv03 on</string>
            <string>ss03 on</string>
          </edit>
        </match>
      '';
    };
  };

  services = {
    # OpenSSH
    openssh = {
      enable = true;
      ports = [ 2222 ];
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
    };

    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
    };

    # Proxy provider
    mihomo = {
      enable = true;
      tunMode = true;
      webui = pkgs.metacubexd;
      configFile = config.age.secrets.mihomo.path;
    };

    # Tailscale
    tailscale = {
      enable = true;
      openFirewall = true;
      interfaceName = "Tailscale";
    };
  };

  environment.systemPackages = with pkgs; [
    tailscale
    nvidia-container-toolkit
    libnvidia-container
  ];

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  # Container runtimes
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  hardware = {
    nvidia = {
      nvidiaSettings = false;
      open = true;
    };
    nvidia-container-toolkit.enable = true;
  };

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

    niri = {
      enable = true;
    };
  };
}
