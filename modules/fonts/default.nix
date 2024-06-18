{
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation {
  name = "maple-mono-NF-CN";
  dontConfigue = true;
  src = fetchzip {
    url = "https://github.com/subframe7536/maple-font/releases/download/v7.0-beta21/MapleMono-NF-CN.zip";
    sha256 = "sha256-r5EDiJ1YyEPTzz0J1bG4dMs7uWvB9kxKS4XPkI7JxGU=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -R $src $out/share/fonts/truetype/
  '';

  meta = {
    description = "Maple Mono NF CN";
    homepage = "https://github.com/subframe7536/maple-font";
  };
}
