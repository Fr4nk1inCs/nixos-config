{
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
in {
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  age = {
    secretsDir = "${config.home.homeDirectory}/.agenix";
    secrets = {
      fr4nk1in-ed25519 = {
        file = ../secrets/fr4nk1in-ed25519.age;
        path = "${config.home.homeDirectory}/.ssh/fr4nk1in-ed25519";
        mode = "0600";
        symlink = false;
      };
      deepseek-apikey.file = ../secrets/deepseek-apikey.age;
      wakatime-cfg = {
        file = ../secrets/wakatime-cfg.age;
        path = "${config.home.homeDirectory}/.wakatime.cfg";
        mode = "0600";
        symlink = false;
      };
      atuin-key = {
        file = ../secrets/atuin-key.age;
        path = "${config.home.homeDirectory}/.local/share/atuin/key";
        mode = "0600";
        symlink = false;
      };
      sshconfig-lab = {
        file = ../secrets/sshconfig-lab.age;
        path = "${config.home.homeDirectory}/.ssh/config.d/lab";
        mode = "0600";
        symlink = true;
      };
    };
  };

  home.packages = [
    inputs.agenix.packages.${system}.agenix
  ];
}
