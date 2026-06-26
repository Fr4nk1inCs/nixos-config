{
  lib,
  fetchFromGitHub,
  flutter344,
  autoPatchelfHook,
  copyDesktopItems,
  keybinder3,
  libayatana-appindicator,
  makeDesktopItem,
  gst_all_1,
  stdenvNoCC,
  fetchurl,
  undmg,
  makeBinaryWrapper,
}:
let
  flutter = flutter344;
  release = lib.importJSON ./release.json;
  inherit (release) version sha256Hashes releaseFilenames;

  description = "A Flutter LLM Chat Client. Support Mobile & Desktop.";

  sourceBuild = flutter.buildFlutterApplication {
    pname = "kelivo";
    inherit version;

    src = fetchFromGitHub {
      owner = "Chevey339";
      repo = "kelivo";
      tag = "v${version}";
      sha256 = sha256Hashes.source;
    };

    pubspecLock = lib.importJSON ./pubspec.lock.json;

    gitHashes = lib.importJSON ./git-hashes.json;

    nativeBuildInputs = [
      autoPatchelfHook
      copyDesktopItems
    ];

    buildInputs = [
      keybinder3
      libayatana-appindicator
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
    ];

    runtimeDependencies = [
      libayatana-appindicator
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "kelivo";
        exec = "kelivo %U";
        icon = "kelivo";
        desktopName = "Kelivo";
        comment = description;
        categories = [
          "Network"
          "Chat"
        ];
      })
    ];

    postInstall = ''
      install -Dm644 assets/app_icon.png \
        $out/share/icons/hicolor/1024x1024/apps/kelivo.png
    '';

    passthru.updateScript = ./update.sh;

    meta = {
      inherit description;
      homepage = "https://github.com/Chevey339/kelivo";
      license = lib.licenses.agpl3Only;
      mainProgram = "kelivo";
      platforms = lib.platforms.linux;
    };
  };

  darwin = stdenvNoCC.mkDerivation {
    inherit (sourceBuild) pname version;

    src = fetchurl {
      url = "https://github.com/Chevey339/kelivo/releases/download/v${version}/${releaseFilenames.aarch64-darwin}";
      sha256 = sha256Hashes.aarch64-darwin-release;
    };

    nativeBuildInputs = [
      undmg
      makeBinaryWrapper
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r kelivo.app $out/Applications/
      makeBinaryWrapper $out/Applications/kelivo.app/Contents/MacOS/kelivo $out/bin/kelivo

      runHook postInstall
    '';

    meta = sourceBuild.meta // {
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = [ "aarch64-darwin" ];
    };
  };
in
if stdenvNoCC.isDarwin then darwin else sourceBuild
