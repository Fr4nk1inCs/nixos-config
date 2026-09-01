_: {
  flake.modules = {
    nixos.xdg = {
      nix.settings.use-xdg-base-directories = true;
    };

    darwin.xdg = {
      nix.settings.use-xdg-base-directories = true;
    };

    homeManager.xdg = { config, ... }: {
      home = {
        preferXdgDirectories = true;

        sessionVariables = with config.xdg; {
          GNUPGHOME = "${configHome}/gnupg";
          DOCKER_CONFIG = "${configHome}/docker";
          WAKATIME_HOME = "${configHome}/wakatime";
          NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
          npm_config_cache = "${cacheHome}/npm";
          TERMINFO_DIRS = "${dataHome}/terminfo:/usr/share/terminfo";
          LESSHISTFILE = "${cacheHome}/less/history";
          CARGO_HOME = "${dataHome}/cargo";
          GOPATH = "${dataHome}/go";
          COPILOT_HOME = "${dataHome}/copilot";
        };
      };

      xdg = {
        enable = true;
        userDirs.enable = true;
        userDirs.setSessionVariables = true;
      };

      nix.settings.use-xdg-base-directories = true;
    };
  };
}
