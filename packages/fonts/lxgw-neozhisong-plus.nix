{
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation rec {
  pname = "lxgw-neozhisong-plus";
  version = "1.064";

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoZhiSong/releases/download/v${version}/LXGWNeoZhiSongPlus.ttf";
    sha256 = "129jhy0scnfl2xprclybq9lypgx15bdpgvwacs3343jwqa2qn366";
  };
  dontConfigure = true;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp $src $out/share/fonts/truetype/
  '';

  meta = {
    description = "LXGW Neo ZhiSong";
    homepage = "https://github.com/lxgw/LxgwNeoZhiSong";
  };
}
