{
  flake.modules.darwin.desktop = {
    system.defaults.CustomUserPreferences."org.hammerspoon.Hammerspoon" = {
      MJConfigFile = "~/.config/hammerspoon/init.lua";
    };

    homebrew.casks = [ "hammerspoon" ];
  };

  flake.modules.homeManager.desktop =
    { pkgs, lib, ... }:
    let
      spoons = "hammerspoon/Spoons";

      fetchOfficialSpoon =
        rev: name: sha256:
        let
          urlBase = "https://github.com/Hammerspoon/Spoons/raw";
          mkSpoonUrl = rev: name: "${urlBase}/${rev}/Spoons/${name}.spoon.zip";
        in
        pkgs.fetchzip {
          inherit sha256;
          url = mkSpoonUrl rev name;
        };

      mkOfficialSpoons =
        spoonsSpec:
        lib.mapAttrs' (name: sha256: {
          name = "${spoons}/${name}.spoon";
          value = {
            source = fetchOfficialSpoon spoonsSpec.officialRev name sha256;
          };
        }) spoonsSpec.officialSpoons;

      mkGitHubSpoons =
        spoonsSpec:
        lib.mapAttrs' (name: value: {
          name = "${spoons}/${name}.spoon";
          value.source = pkgs.fetchFromGitHub value;
        }) spoonsSpec.GitHubSpoons;

      mkSpoons =
        spoonsSpec: (mkOfficialSpoons spoonsSpec) // (mkGitHubSpoons spoonsSpec);
    in
    {
      xdg.configFile = lib.optionalAttrs pkgs.stdenv.isDarwin (
        {
          "hammerspoon/init.lua".source = ./hammerspoon.lua;
        }
        // (mkSpoons (builtins.fromJSON (builtins.readFile ./spoons.json)))
      );
    };
}
