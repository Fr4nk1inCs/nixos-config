{
  bun2nix,
  lib,
  plannotatorSrc,
  stdenvNoCC,
  fetchurl,
  ...
}: let
  transformedSrc = stdenvNoCC.mkDerivation {
    name = "plannotator-bun2nix-source";
    src = plannotatorSrc;
    nativeBuildInputs = [bun2nix];
    buildPhase = ''
      runHook preBuild

      export HOME=$TMPDIR
      bun2nix -o ./bun.nix

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r ./. $out/

      runHook postInstall
    '';
  };
in
  # FIXME: we need this because bun2nix cannot handle workspaces correctly.
  if stdenvNoCC.hostPlatform.system == "x86_64-linux"
  then
    stdenvNoCC.mkDerivation rec {
      pname = "plannotator";
      version = "0.10.0";

      src = fetchurl {
        url = "https://github.com/backnotprop/plannotator/releases/download/v0.10.0/plannotator-linux-x64";
        hash = "sha256-Jouu9nP0k+BQ/aDgwepv3YOtax8kNNbJVvn/GtmZqgU=";
        executable = true;
      };

      phases = ["installPhase"];

      installPhase = ''
        mkdir -p $out/bin
        cp ${src} $out/bin/plannotator
      '';
    }
  else
    bun2nix.mkDerivation rec {
      pname = "plannotator";

      src = transformedSrc;

      packageJson = "${src}/package.json";

      bunDeps = bun2nix.fetchBunDeps {
        bunNix = "${src}/bun.nix";
      };

      buildPhase = ''
        runHook preBuild

        export HOME=$TMPDIR
        bun run build:review
        bun run build:hook
        bun build apps/hook/server/index.ts --compile --outfile plannotator

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        cp plannotator $out/bin/plannotator

        runHook postInstall
      '';

      meta = {
        description = "Interactive Plan Review for AI Coding Agents";
        homepage = "https://plannotator.ai";
        license = with lib.licenses; [
          mit
          asl20
        ];
        platforms = lib.platforms.all;
        mainProgram = "plannotator";
      };
    }
