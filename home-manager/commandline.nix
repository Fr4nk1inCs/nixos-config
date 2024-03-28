{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Shell
    zsh
    starship
    zsh-autosuggestions
    # CLI tools
    bat
    btop
    eza
    fzf
    ripgrep
    zoxide
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;

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
