_: {
  flake.modules = {
    nixos.xdg = {
      nix.settings.use-xdg-base-directories = true;
    };

    darwin.xdg = { config, ... }: {
      nix.settings.use-xdg-base-directories = true;

      homebrew.onActivation.extraEnv = {
        XDG_CONFIG_HOME =
          config.home-manager.users.${config.system.primaryUser}.xdg.configHome;
      };
    };

    homeManager.xdg =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        inherit (pkgs.stdenv.hostPlatform) isLinux;
      in
      {
        home = {
          preferXdgDirectories = true;

          sessionVariables = with config.xdg; {
            GNUPGHOME = "${configHome}/gnupg";
            DOCKER_CONFIG = "${configHome}/docker";
            NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
            npm_config_cache = "${cacheHome}/npm";
            TERMINFO_DIRS = "${dataHome}/terminfo:/usr/share/terminfo";
            LESSHISTFILE = "${cacheHome}/less/history";
            CARGO_HOME = "${dataHome}/cargo";
            GOPATH = "${dataHome}/go";
            COPILOT_HOME = "${dataHome}/copilot";
            IPYTHONDIR = "${configHome}/ipython";
            PYTHON_HISTORY = "${stateHome}/python/history";
            CUDA_CACHE_PATH = "${cacheHome}/nv/ComputeCache";
          };

          pointerCursor = lib.mkIf (isLinux && config.stylix.enable) {
            dotIcons.enable = false;
          };
        };

        home.file =
          lib.mkIf (isLinux && config.stylix.targets.gtk.flatpakSupport.enable)
            {
              ".themes/${config.gtk.theme.name}".target =
                "${config.xdg.dataHome}/themes/${config.gtk.theme.name}";
            };

        xdg.dataFile."flatpak/overrides/global" =
          lib.mkIf (isLinux && config.stylix.targets.gtk.flatpakSupport.enable)
            {
              text = lib.mkForce ''
                [Context]
                filesystems=${config.xdg.dataHome}/themes/${config.gtk.theme.name}:ro

                [Environment]
                GTK_THEME=${config.gtk.theme.name}
              '';
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
