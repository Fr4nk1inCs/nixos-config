{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

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

    historySubstringSearch = {
      enable = true;
      searchDownKey = [
        "^[[B"
        "^[OB"
      ];
      searchUpKey = [
        "^[[A"
        "^[OA"
      ];
    };

    shellAliases = {
      ":q" = "exit";
    };

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
      # {
      #   name = "zsh-vi-mode";
      #   src = pkgs.zsh-vi-mode;
      #   file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      # }
    ];

    localVariables = {
      ZVM_VI_HIGHLIGHT_FOREGROUND = "white";
      ZVM_VI_HIGHLIGHT_BACKGROUND = "#434c5e";
    };

    initExtra = ''
      setopt interactivecomments
      bindkey -v

      # fix fzf-tab configuration
      zstyle ':fzf-tab:*' fzf-flags ''${(z)FZF_DEFAULT_OPTS}
    '';

    envExtra = ''
      export DEEPSEEK_API_KEY=$(cat ${config.age.secrets.deepseek-apikey.path})
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      command_timeout = 1000;
    };
  };
}
