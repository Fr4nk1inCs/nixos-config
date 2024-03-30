{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

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

    antidote = {
      enable = true;
      plugins = [
        "wbingli/zsh-wakatime"
        "Aloxaf/fzf-tab"
      ];
    };
  };
  
  programs.starship = {
    enable = true;
  };
}
