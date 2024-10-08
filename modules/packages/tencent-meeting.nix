{
  undmg,
  stdenvNoCC,
  fetchurl,
  lib,
  ...
}: let
  name = "tencent-meeting";
  version = "3.29.3.488";
  url = "https://updatecdn.meeting.qq.com/cos/944cc0eb51fe4b46223d62f9bef82ef3/TencentMeeting_0300000000_3.29.3.488.publish.arm64.officialwebsite.dmg";
  app = "TencentMeeting.app";
in
  stdenvNoCC.mkDerivation {
    inherit name version;

    src = fetchurl {
      inherit url;
      name = "${name}.dmg";
      sha256 = "sha256-5gN/IVxNonumjOK2OEkhlpURGguwfe/MF+r1lWBro00=";
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
      description = "基于腾讯20多年音视频通讯经验，腾讯会议提供一站式音视频会议解决方案，让您能随时随地体验高清流畅的会议以及会议协作。";
      homepage = "https://meeting.tencent.com/";
      license = licenses.unfree;
      platforms = ["aarch64-darwin"];
    };
  }
