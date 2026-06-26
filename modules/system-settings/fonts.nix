{ self, ... }: {
  flake.constants.fontFeatures = {
    maple-mono = {
      on = [
        "calt"
        "cv01"
        "cv03"
        "ss03"
      ];
      off = [ ];
    };
  };

  flake.modules = {
    nixos.fonts = { pkgs, ... }: {
      fonts = {
        packages = with pkgs; [
          harmonyos-sans
          noto-fonts-color-emoji
          maple-mono.NF-CN
          lxgw-neozhisong-plus
        ];
        fontconfig = {
          defaultFonts = {
            sansSerif = [ "HarmonyOS Sans SC" ];
            serif = [ "LXGW Neo ZhiSong Plus" ];
            monospace = [ "Maple Mono NF CN" ];
            emoji = [ "Noto Color Emoji" ];
          };

          localConf = ''
            <match target="font">
              <test name="family" compare="eq" ignore-blanks="true">
                <string>Maple Mono NF CN</string>
              </test>
              <edit name="fontfeatures" mode="assign_replace">
            ${self.lib.fontFeatures.toFontConfig self.constants.fontFeatures.maple-mono "    "}
              </edit>
            </match>
          '';
        };
      };
    };

    darwin.fonts = { pkgs, ... }: {
      homebrew.casks = [
        "font-sf-pro"
      ];

      fonts.packages = with pkgs; [
        harmonyos-sans
        lxgw-neozhisong-plus
        maple-mono.NF-CN
        libertinus
      ];
    };

    homeManager.fonts = { pkgs, lib, ... }: {
      home.packages = [
        pkgs.harmonyos-sans
        pkgs.lxgw-neozhisong-plus
        pkgs.maple-mono.NF-CN
        pkgs.libertinus
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        pkgs.noto-fonts-color-emoji
        pkgs.fandol-fonts
      ];

      fonts.fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = [ "HarmonyOS Sans SC" ];
          serif = [ "LXGW Neo ZhiSong Plus" ];
          monospace = [ "Maple Mono NF CN" ];
        }
        // lib.optionalAttrs pkgs.stdenv.isLinux {
          emoji = [ "Noto Color Emoji" ];
          serif = lib.mkBefore [ "Libertinus Serif Display" ];
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          emoji = [ "Apple Color Emoji" ];
          sansSerif = lib.mkBefore [
            "SF Pro"
            "PingFang SC"
          ];
          serif = lib.mkBefore [
            "Libertinus Serif Display"
          ];
        };
      };

      stylix = {
        targets.fontconfig.enable = false;
        targets.font-packages.enable = false;

        fonts = {
          monospace = {
            name = "Maple Mono NF CN";
            package = pkgs.maple-mono.NF-CN;
          };
        }
        // lib.optionalAttrs pkgs.stdenv.isLinux {
          sansSerif = {
            name = "HarmonyOS Sans SC";
            package = pkgs.harmonyos-sans;
          };
          serif = {
            name = "LXGW Neo ZhiSong Plus";
            package = pkgs.lxgw-neozhisong-plus;
          };
          emoji = {
            name = "Noto Color Emoji";
            package = pkgs.noto-fonts-color-emoji;
          };
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          sansSerif = {
            name = "SF Pro";
            package = pkgs.maple-mono.NF-CN;
          };
          serif = {
            name = "New York";
            package = pkgs.maple-mono.NF-CN;
          };
          emoji = {
            name = "Apple Color Emoji";
            package = pkgs.maple-mono.NF-CN;
          };
        };
      };

      xdg.configFile."fontconfig/conf.d/75-fontfeatures-maple.conf".text = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:font.dtd">
        <fontconfig>
          <description>Enable some fontfeatures for Maple Mono NF CN</description>
          <match target="font">
            <test name="family" compare="eq" ignore-blanks="true">
              <string>Maple Mono NF CN</string>
            </test>
            <edit name="fontfeatures" mode="append">
        ${self.lib.fontFeatures.toFontConfig self.constants.fontFeatures.maple-mono "      "}
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };
}
