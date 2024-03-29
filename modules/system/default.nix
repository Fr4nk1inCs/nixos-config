{ pkgs, lib, ... }:

{
  # Password is needed when using sudo
  security.sudo.wheelNeedsPassword = true;

  # Locale setting
  i18n.defaultLocale = "zh_CN.UTF-8";
  time.timeZone = "Asia/Shanghai";

  nix.settings = {
    # Enable flakes globally
    experimental-features = ["nix-command" "flakes"];

    # Cache mirror located in China
    substituters = [
      # status: https://mirror.sjtu.edu.cn/
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # status: https://mirrors.ustc.edu.cn/status
      "https://mirrors.ustc.edu.cn/nix-channels/store"

      # nix community's cache server
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      # nix community's cache server public key
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Garbage collection
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Allow using non-free software
  nixpkgs.config.allowUnfree = true;

  # Basic packages to maintain a minimal usable shell
  environment.systemPackages = with pkgs; [
    git
    vim
    neovim
    wget
    curl

    zsh
    starship
  ];

  # Setting default editor to vim
  environment.variables.EDITOR = "nvim";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  programs.starship = {
    enable = true;
  };
}
