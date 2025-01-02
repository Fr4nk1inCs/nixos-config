{
  stdenvNoCC,
  fetchurl,
  lib,
}:
stdenvNoCC.mkDerivation {
  name = "fira-math";
  version = "0.3.4";

  dontConfigue = true;

  src = fetchurl {
    url = "https://github.com/firamath/firamath/releases/download/v0.3.4/FiraMath-Regular.otf";
    sha256 = "sha256-ICjL091NjAzxYIUg60dZlWqDpnkx17bY58MTUgGG41s=";
  };

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype/
    cp $src $out/share/fonts/opentype/
  '';

  meta = with lib; {
    description = "Math font with Unicode math support based on FiraSans and FiraGO";
    homepage = "https://github.com/firamath/firamath";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
