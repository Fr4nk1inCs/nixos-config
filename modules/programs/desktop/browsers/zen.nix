{ inputs, ... }: {
  flake.modules.homeManager.desktop =
    { pkgs, config, ... }:
    let
      inherit (config.home) username;
    in
    {
      imports = [
        inputs.zen-browser.homeModules.default
      ];

      stylix.targets.zen-browser.profileNames = [ username ];

      # TODO: Spaces
      programs.zen-browser = {
        enable = pkgs.stdenv.isLinux;
        setAsDefaultBrowser = true;

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

            ExtensionSettings = mkExtensionSettings {
              "{fb25c100-22ce-4d5a-be7e-75f3d6f0fc13}" = "kiss-translator";
              "{8e515334-52b5-4cc5-b4e8-675d50af677d}" = "scriptcat";
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
              "uBlock0@raymondhill.net" = "ublock-origin";
            };
          };

        profiles.${username} = {
          settings = {
            "zen.ui.migration.compact-mode-button-added" = true;
            "zen.view.compact.enable-at-startup" = false;
            "zen.view.use-single-toolbar" = false;
            "zen.welcome-screen.seen" = true;
          };
        };
      };
    };
}
