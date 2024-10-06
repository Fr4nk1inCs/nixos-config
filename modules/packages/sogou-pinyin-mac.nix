{
  stdenvNoCC,
  fetchzip,
  lib,
  ...
}: let
  pname = "sogou_mac";
  shortVersion = "615c";
  appName = "${pname}_${shortVersion}.app";
  stdAppName = "Install Sogou Pinyin.app";
in
  stdenvNoCC.mkDerivation {
    name = "sogouinput";
    version = "6.15.2";

    src = fetchzip {
      extension = "zip";
      url = "https://rabbit-linker.vercel.app/gtimg/${pname}/${shortVersion}";
      sha256 = "sha256-gVZmvkrFKHc8y7lWc80T9o6TUw33safS8M79MSZBkbU=";
      stripRoot = false;
    };

    installPhase = ''
      mkdir -p $out/Applications/
      mv ${appName} "$out/Applications/${stdAppName}"
    '';

    meta = with lib; {
      description = "Sogou Pinyin Input Method for macOS";
      homepage = "https://pinyin.sogou.com/mac/";
      license = licenses.unfree;
      platforms = platforms.darwin;
    };
  }
