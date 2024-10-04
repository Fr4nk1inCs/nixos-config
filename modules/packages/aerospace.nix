{
  stdenvNoCC,
  fetchzip,
  lib,
  installShellFiles,
  ...
}: let
  name = "AeroSpace";
  version = "0.14.2-Beta";
  app = "${name}.app";
in
  stdenvNoCC.mkDerivation {
    name = "AeroSpace";
    inherit version;

    src = fetchzip {
      url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${version}/AeroSpace-v${version}.zip";
      sha256 = "sha256-v2D/IV9Va0zbGHEwSGt6jvDqQYqha290Lm6u+nZTS3A=";
      stripRoot = true;
    };

    nativeBuildInputs = [installShellFiles];

    installPhase = ''
      mkdir -p $out/Applications/
      mv ${app} $out/Applications

      mkdir -p $out/bin
      mv bin/* $out/bin

      # Man page
      installManPage $src/manpage/*
      # Shell completion
      installShellCompletion --bash --name aerospace.bash $src/shell-completion/bash/aerospace
      installShellCompletion --zsh  --name _aerospace     $src/shell-completion/zsh/_aerospace
      installShellCompletion --fish --name aerospace.fish $src/shell-completion/fish/aerospace.fish
    '';

    meta = with lib; {
      description = "AeroSpace is an i3-like tiling window manager for macOS";
      homepage = "https://github.com/nikitabobko/AeroSpace";
      license = licenses.mit;
      platforms = platforms.darwin;
    };
  }
