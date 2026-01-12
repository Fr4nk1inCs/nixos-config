# https://github.com/nix-community/nur-combined/blob/main/repos/guanran928/pkgs/misans/package.nix
{
  lib,
  stdenvNoCC,
  fetchzip,
}: let
  types = {
    opentype = {
      inDir = "otf";
      outDir = "opentype";
      extension = "otf";
    };
    truetype = {
      inDir = "ttf";
      outDir = "truetype";
      extension = "ttf";
    };
    variable = {
      inDir = ".";
      outDir = "truetype";
      extension = "ttf";
    };
    woff = {
      inDir = "woff";
      outDir = "woff";
      extension = "woff";
    };
    woff2 = {
      inDir = "woff2";
      outDir = "woff2";
      extension = "woff2";
    };
  };

  misans = {
    typename,
    inDir,
    outDir,
    extension,
  }:
    stdenvNoCC.mkDerivation {
      pname = "misans-${typename}";
      version = "4.003"; # from font metadata
      src = fetchzip {
        url = "https://hyperos.mi.com/font-download/MiSans.zip";
        hash = "sha256-497H20SYzzUFaUHkqUkYlROLrqXRBLkBkylsRqZ6KfM=";
        stripRoot = false;
      };

      dontPatch = true;
      dontConfigure = true;
      dontBuild = true;
      doCheck = false;
      dontFixup = true;

      installPhase = ''
        runHook preInstall

        install -Dm644 -t $out/share/fonts/${outDir} MiSans/${inDir}/MiSans*.${extension}

        runHook postInstall
      '';

      meta = {
        homepage = "https://hyperos.mi.com/font/";
        description = "MiSans font";
        platforms = lib.platforms.all;
        license = lib.licenses.unfree; # https://hyperos.mi.com/font-download/MiSans字体知识产权许可协议.pdf
      };
    };

  combinedFonts =
    lib.concatMapAttrs (
      typename: typeInfo: {
        "${typename}" = misans {
          inherit typename;
          inherit (typeInfo) inDir outDir extension;
        };
      }
    )
    types;
in
  combinedFonts
