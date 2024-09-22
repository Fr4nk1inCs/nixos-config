{
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation {
  name = "maple-mono-NF-CN";
  dontConfigue = true;
  src = fetchzip {
    url = "https://github.com/subframe7536/maple-font/releases/download/v7.0-beta26/MapleMono-NF-CN.zip";
    sha256 = "sha256-ez+7uIuZSaSH7ImU4W7w0ZlB9rceCtRoLuZzC0i0AQc=";
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
