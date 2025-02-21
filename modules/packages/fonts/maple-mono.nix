{
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation {
  name = "maple-mono-NF-CN";
  dontConfigue = true;
  src = fetchzip {
    url = "https://github.com/subframe7536/maple-font/releases/download/v7.0-beta36/MapleMono-NF-CN.zip";
    sha256 = "sha256-CD7Nu9M2aB355GH0+KMlS4ykQXsrmwvQ2oufu4QC5HU=";
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
