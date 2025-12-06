{pkgs, ...}: {
  home.packages = [
    pkgs.fonts.misans.variable # sans-serif
    pkgs.source-han-serif # serif
    pkgs.maple-mono.NF-CN # monospace
    pkgs.noto-fonts-color-emoji # emoji

    # document writing
    pkgs.libertinus # math
    pkgs.fonts.fandol
    pkgs.fira
    pkgs.fonts.fira-math
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = ["SF Pro" "PingFang SC" "MiSans VF"];
      serif = ["New York" "Songti SC" "Source Han Serif SC"];
      monospace = ["Maple Mono NF CN"];
      emoji = ["Apple Color Emoji" "Noto Color Emoji"];
    };
  };

  xdg.configFile = {
    "fontconfig/conf.d/75-fontfeatures-maple-mono-nf-cn.conf".text = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:font.dtd">
      <fontconfig>
        <description>Enable some fontfeatures for Maple Mono NF CN</description>
        <match target="font">
          <test name="family" compare="eq" ignore-blanks="true">
            <string>Maple Mono NF CN</string>
          </test>
          <edit name="fontfeatures" mode="append">
            <string>calt on</string>
            <string>cv01 on</string>
            <string>cv03 on</string>
            <string>ss03 on</string>
          </edit>
        </match>
      </fontconfig>
    '';
  };
}
