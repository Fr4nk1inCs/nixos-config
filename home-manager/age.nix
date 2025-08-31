{
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  HOME = config.home.homeDirectory;
in {
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  age = {
    secretsDir = "${HOME}/.agenix";
    secrets = {
      fr4nk1in-ed25519 = {
        file = ../secrets/fr4nk1in-ed25519.age;
        path = "${HOME}/.ssh/fr4nk1in-ed25519";
        mode = "0600";
        symlink = false;
      };
      whisk = {
        file = ../secrets/whisk.age;
        path = "${HOME}/.ssh/whisk";
        mode = "0600";
        symlink = false;
      };
      deepseek-apikey.file = ../secrets/deepseek-apikey.age;
      wakatime-cfg = {
        file = ../secrets/wakatime-cfg.age;
        path = "${HOME}/.wakatime.cfg";
        mode = "0600";
        symlink = false;
      };
      atuin-key = {
        file = ../secrets/atuin-key.age;
        path = "${HOME}/.local/share/atuin/key";
        mode = "0600";
        symlink = false;
      };
      sshconfig-lab = {
        file = ../secrets/sshconfig-lab.age;
        path = "${HOME}/.ssh/config.d/lab";
      };
      sshconfig-personal = {
        file = ../secrets/sshconfig-personal.age;
        path = "${HOME}/.ssh/config.d/personal";
      };
    };
  };

  home.packages = [
    inputs.agenix.packages.${system}.agenix
  ];
}
