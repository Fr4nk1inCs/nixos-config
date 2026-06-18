_:
let
  common-configs = {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];

      substituters = [
        # status: https://mirrors.ustc.edu.cn/status
        "https://mirrors.ustc.edu.cn/nix-channels/store"

        "https://cache.nixos.org"

        # nix community's cache server
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      download-buffer-size = 1024 * 1024 * 1024;
    };
  };
in
{
  flake.modules.darwin.system-minimal = common-configs;
  flake.modules.nixos.system-minimal = common-configs;
}
