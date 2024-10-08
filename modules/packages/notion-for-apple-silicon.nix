#
{
  stdenvNoCC,
  fetchurl,
  undmg,
  lib,
  ...
}: let
  name = "Notion";
  version = "3.16.0";
  app = "${name}.app";
in
  stdenvNoCC.mkDerivation {
    inherit name version;

    src = fetchurl {
      name = "${name}.dmg";
      url = "https://desktop-release.notion-static.com/${name}-${version}-arm64.dmg";
      sha256 = "sha256-85q6Y9L4qSiirifqe6+S/S+Gn9WputHWgs9rHedfMjk=";
    };

    nativeBuildInputs = [undmg];

    unpackPhase = ''
      undmg $src
    '';

    installPhase = ''
      mkdir -p $out/Applications/${app}
      mv ${app} $out/Applications/
    '';

    meta = with lib; {
      description = "Notion: Your connected workspace for wiki, docs & projects";
      homepage = "https://www.notion.so/";
      license = licenses.unfree;
      platforms = ["aarch64-darwin"];
    };
  }
