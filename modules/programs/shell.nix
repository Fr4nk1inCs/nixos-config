{
  flake.modules = {
    nixos.shell = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
      };

      programs.starship.enable = true;
    };

    darwin.shell = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableSyntaxHighlighting = true;
      };
    };

    homeManager.shell =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        home.shellAliases = {
          ":q" = "exit";
        };

        home.shell.enableShellIntegration = true;

        programs = {
          zsh = {
            enable = true;
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;

            dotDir = "${config.xdg.configHome}/zsh";

            completionInit = "autoload -U compinit && compinit -i";

            history = {
              size = 50000;
              save = 10000;
              share = true;
              extended = true;
              expireDuplicatesFirst = true;
              ignoreAllDups = true;
              ignoreSpace = true;
              saveNoDups = true;
            };

            historySubstringSearch.enable = false;

            plugins = [
              {
                name = "zsh-nix-shell";
                src = pkgs.zsh-nix-shell;
                file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
              }
              {
                name = "fzf-tab";
                src = pkgs.zsh-fzf-tab;
                file = "share/fzf-tab/fzf-tab.plugin.zsh";
              }
              {
                name = "zsh-wakatime";
                src = pkgs.fetchFromGitHub {
                  owner = "wbingli";
                  repo = "zsh-wakatime";
                  rev = "e0d1dfcaaab11112344e14b826f3136edac4eccc";
                  hash = "sha256-QN/MUDm+hVJUMA4PDqs0zn9XC2wQZrgQr4zmCF0Vruk=";
                };
              }
            ];

            localVariables = {
              ZVM_VI_HIGHLIGHT_FOREGROUND = "#cdcecf";
              ZVM_VI_HIGHLIGHT_BACKGROUND = "#434c5e";
            };

            initContent = ''
              setopt interactivecomments
              bindkey -v
              bindkey -M vicmd v edit-command-line

              # fix fzf-tab configuration
              zstyle ':fzf-tab:*' fzf-flags ''${(z)FZF_DEFAULT_OPTS}
            ''
            + lib.optionalString (pkgs.stdenv.isAarch64 && pkgs.stdenv.isDarwin) ''
              eval "$(/opt/homebrew/bin/brew shellenv)"
            '';

          };

          starship = {
            enable = true;
            settings = {
              command_timeout = 1000;
            };
          };

          atuin = {
            enable = true;
            daemon.enable = true;
            settings = {
              style = "full";
              key_path = "${config.xdg.dataHome}/atuin/key";
            };
          };
        };
      };
  };
}
