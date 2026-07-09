{ inputs, ... }: {
  flake.modules = {
    nixos.cli = {
      programs.git = {
        enable = true;
        lfs.enable = true;
      };
    };

    darwin.cli = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        git
        git-lfs
      ];
    };

    homeManager.cli =
      { config, lib, ... }:
      let
        inherit (config.lib.stylix) colors;
        hex = name: colors.withHashtag.${name};
        rgb = name: {
          r = lib.fromHexString colors."${name}-hex-r";
          g = lib.fromHexString colors."${name}-hex-g";
          b = lib.fromHexString colors."${name}-hex-b";
        };
        fromRgb =
          rgb: with lib; "#${toHexString rgb.r}${toHexString rgb.g}${toHexString rgb.b}";
        blend =
          fgName: bgName: pct:
          let
            fg = rgb fgName;
            bg = rgb bgName;
            mix = a: b: lib.min (builtins.div (a * pct + b * (100 - pct) + 50) 100) 255;
          in
          fromRgb {
            r = mix fg.r bg.r;
            g = mix fg.g bg.g;
            b = mix fg.b bg.b;
          };
        hunkTheme = {
          base =
            if config.stylix.polarity == "light" then
              "github-light-default"
            else
              "github-dark-default";
          label = "Stylix";
          # Chrome / surfaces
          background = hex "base00";
          panel = hex "base01";
          panelAlt = hex "base02";
          border = hex "base03";
          text = hex "base05";
          muted = hex "base03";
          accent = hex "base0D";
          accentMuted = hex "base0C";
          lineNumberBg = hex "base01";
          lineNumberFg = hex "base03";
          selectedHunk = blend "base0D" "base00" 18;
          # Diff line backgrounds (blended over the stylix background)
          addedBg = blend "base0B" "base00" 12;
          removedBg = blend "base08" "base00" 12;
          addedContentBg = blend "base0B" "base00" 20;
          removedContentBg = blend "base08" "base00" 20;
          movedAddedBg = blend "base0C" "base00" 12;
          movedRemovedBg = blend "base09" "base00" 12;
          contextBg = hex "base00";
          contextContentBg = hex "base00";
          addedSignColor = hex "base0B";
          removedSignColor = hex "base08";
          # Badges + file status
          badgeAdded = hex "base0B";
          badgeRemoved = hex "base08";
          badgeNeutral = hex "base03";
          fileNew = hex "base0B";
          fileDeleted = hex "base08";
          fileModified = hex "base0D";
          fileRenamed = hex "base0E";
          fileUntracked = hex "base0A";
          # Inline agent/AI notes
          noteBorder = hex "base0E";
          noteBackground = hex "base01";
          noteTitleBackground = blend "base0E" "base00" 25;
          noteTitleText = hex "base05";
          syntax = {
            default = hex "base05";
            keyword = hex "base0E";
            string = hex "base0B";
            comment = hex "base03";
            number = hex "base09";
            function = hex "base0D";
            property = hex "base0C";
            type = hex "base0A";
            variable = hex "base05";
            operator = hex "base05";
            punctuation = hex "base05";
          };
        };
      in
      {
        imports = [
          inputs.hunk.homeManagerModules.default
        ];

        programs = {
          gh.enable = true;

          git = {
            enable = true;
            lfs.enable = true;
            signing.format = "openpgp";
          };

          hunk = {
            enable = true;
            enableGitIntegration = true;
            settings = {
              theme = "custom";
              custom_theme = hunkTheme;
              mode = "auto";
              line_numbers = true;
              watch = true;
              wrap_lines = true;
              agent_notes = true;
            };
          };

          lazygit = {
            enable = true;

            settings = {
              os.editPreset = "nvim-remote";

              gui = {
                nerdFontsVersion = "3";
              };

              git.pagers = [ { pager = "hunk pager"; } ];
              git.parseEmoji = true;
            };
          };
        };
      };

  };
}
