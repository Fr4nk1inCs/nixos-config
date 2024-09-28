{
  pkgs,
  lib,
  ...
}: {
  # Default user
  users.users = {
    fushen = {
      description = "Shen Fu";
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

  # Locale setting
  time.timeZone = "Asia/Shanghai";

  # Garbage collection
  nix.gc = {
    automatic = lib.mkDefault true;
    options = lib.mkDefault "--delete-older-than 7d";
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
}
