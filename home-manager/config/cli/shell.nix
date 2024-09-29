{pkgs, ...}: {
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
      ignoreDups = true;
      ignoreSpace = true;
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
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
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

    initExtra = "setopt interactivecomments";
  };

  programs.starship = {
    enable = true;
    settings = {
      command_timeout = 1000;
    };
  };
}
