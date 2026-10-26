{ inputs, ... }: {
  flake.modules.homeManager.desktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (config.home) username;
    in
    {
      imports = [
        inputs.zen-browser.homeModules.default
      ];

      stylix.targets.zen-browser.profileNames = [ username ];

      programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = true;
        env = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          MOZ_APP_DATA = config.programs.zen-browser.configPath;
        };

        policies =
          let
            mkExtensionSettings = builtins.mapAttrs (
              _: pluginId: {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
                installation_mode = "force_installed";
              }
            );
          in
          {
            AIControls.Default.Value = "blocked";
            AutofillAddressEnabled = true;
            AutofillCreditCardEnabled = false;
            DisableAppUpdate = true;
            DisableFeedbackCommands = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableTelemetry = true;
            DontCheckDefaultBrowser = true;
            NoDefaultBookmarks = true;
            OfferToSaveLogins = false;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };

            ExtensionSettings =
              (mkExtensionSettings {
                "{fb25c100-22ce-4d5a-be7e-75f3d6f0fc13}" = "kiss-translator";
                "{8e515334-52b5-4cc5-b4e8-675d50af677d}" = "scriptcat";
                "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
                "uBlock0@raymondhill.net" = "ublock-origin";
                "jid0-oFxt2GoakYukFl7Yp42Kq@jetpack" = "webrtc-control";
              })
              // {
                "zotero@chnm.gmu.edu" = {
                  install_url = "https://www.zotero.org/download/connector/dl?browser=firefox";
                  installation_mode = "force_installed";
                };
              };
          };

        profiles.${username} = {
          isDefault = true;
          search = {
            default = "google";
            force = true;
          };
          settings = {
            "browser.startup.page" = 3;
            "browser.urlbar.trimURLs" = true;
            "browser.warnOnQuitShortcut" = false;
            "devtools.jsonview.enabled" = true;
            "font.name.monospace.x-western" = "Maple Mono NF CN";
            "font.name.monospace.zh-CN" = "Maple Mono NF CN";
            "font.name.serif.x-math" = "Libertinus Math";
            "intl.accept_languages" = "zh-CN,en,zh";
            "layout.css.prefers-color-scheme.content-override" = 1;
            "sidebar.main.tools" = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
            "sidebar.visibility" = "hide-on-close";
            "zen.ui.migration.compact-mode-button-added" = true;
            "zen.view.compact.enable-at-startup" = false;
            "zen.view.use-single-toolbar" = false;
            "zen.welcome-screen.seen" = true;
            "zen.window-sync.enabled" = true;
            "zen.window-sync.sync-only-pinned-tabs" = true;
          };

          extensionButtons = {
            nav-bar = [
              "uBlock0@raymondhill.net"
              "{446900e4-71c2-419f-a6a7-df9c091e268b}"
              "zotero@chnm.gmu.edu"
              "jid0-oFxt2GoakYukFl7Yp42Kq@jetpack"
              "{fb25c100-22ce-4d5a-be7e-75f3d6f0fc13}"
            ];
          };

          pinsForce = true;
          pinsForceAction = "remove";
          spacesForce = true;
          sessionStore = lib.importJSON ./zen.json;

          spaceRouting = {
            force = false;
            defaultExternalRoute = "most-recent-space";
          };
        };
      };
    };
}
