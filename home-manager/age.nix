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
    };
  };

  home.packages = [
    inputs.agenix.packages.${system}.agenix
  ];
}
