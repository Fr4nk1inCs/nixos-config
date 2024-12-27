{
  stdenvNoCC,
  fetchzip,
  lib,
  ...
}: let
  pname = "sogou_mac";
  shortVersion = "616a";
  appName = "${pname}_${shortVersion}.app";
  stdAppName = "Install Sogou Pinyin.app";
in
  stdenvNoCC.mkDerivation {
    name = "sogouinput";
    version = "6.16.0";

    src = fetchzip {
      extension = "zip";
      url = "https://rabbit-linker.vercel.app/gtimg/${pname}/${shortVersion}";
      sha256 = "sha256-JeUmcgMrVLsO70fEMAsfoZCO+a8rtCJ3u4yY5bNeH1I=";
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
