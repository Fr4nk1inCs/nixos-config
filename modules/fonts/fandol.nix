{
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation {
  name = "otf-fandol";
  dontConfigue = true;
  src = fetchzip {
    url = "https://mirrors.ctan.org/fonts/fandol.zip";
    sha256 = "sha256-rvvsrB5NajDPT1QrsQWmyQnzyz30l1jc4KZogK8LNKU=";
    stripRoot = true;
  };

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -R $src $out/share/fonts/opentype/
  '';

  meta = {
    description = "Fandol";
    homepage = "https://ctan.org/pkg/fandol";
  };
}
