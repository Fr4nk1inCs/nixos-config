{
  bun2nix,
  lib,
  plannotatorSrc,
  stdenvNoCC,
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
