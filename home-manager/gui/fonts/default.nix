{
  config,
  pkgs,
  lib,
  ...
}: let
  enable = config.homeMangerConfig.gui.enable;
  maple-mono-NF-CN = pkgs.callPackage ../../../modules/fonts/maple-mono-NF-CN.nix {};
in {
  config = lib.optionalAttrs {
    home.packages = with pkgs; [
      inter # sans-serif
      source-han-sans # sans-serif for CJK
      source-han-serif # serif
      maple-mono-NF-CN # monospace
      noto-fonts-color-emoji # emoji
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = ["Inter Display" "Source Han Sans SC"];
        serif = ["Source Han Serif SC"];
        monospace = ["Maple Mono NF CN"];
        emoji = ["Noto Color Emoji"];
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
              <string>cv01 on</string>
              <string>cv03 on</string>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };
}
