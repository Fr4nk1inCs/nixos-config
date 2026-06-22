{
  flake.modules.darwin.desktop = {
    system.defaults.CustomUserPreferences = {
      "com.apple.inputmethod.CoreChineseEnigneFramework" = {
        candidateWindowDirection = 0;
        fontSize = 14;
        usesHalfwidthPunctuation = 1;
      };
    };
  };

  flake.modules.homeManager.desktop = { pkgs, lib, ... }: {
    i18n.inputMethod = lib.optionalAttrs pkgs.stdenv.isLinux {
      type = "fcitx5";
      enable = true;
      fcitx5 = {
        addons = with pkgs; [
          (fcitx5-rime.override {
            rime-data = rime-ice;
          })
        ];

        settings.addons = {
          clipboard.globalSection.TriggerKey = null;
          rime.globalSection.SwitchInputMethodBehavior = "Commit composing text";
        };

        waylandFrontend = true;
      };
    };

    xdg.dataFile =
      let
        yamlFormat = pkgs.formats.yaml { };
      in
      lib.optionalAttrs pkgs.stdenv.isLinux {
        "fcitx5/rime/default.custom.yaml".source =
          yamlFormat.generate "default.custom.yaml"
            {
              patch = {
                __include = "rime_ice_suggestion:/";

                schema_list = [ { schema = "rime_ice"; } ];

                menu.page_size = 9;
              };
            };
      };
  };
}
