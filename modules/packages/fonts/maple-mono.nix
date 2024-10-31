{
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation {
  name = "maple-mono-NF-CN";
  dontConfigue = true;
  src = fetchzip {
    url = "https://github.com/subframe7536/maple-font/releases/download/v7.0-beta29/MapleMono-NF-CN.zip";
    sha256 = "sha256-ybCeft2/i7UY3C/Pew76RiwVEM+vzUtDQuvr4dAkaUY=";
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
