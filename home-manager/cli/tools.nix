{pkgs, ...}: {
  home.packages = with pkgs; [
    fd
    tldr
    wakatime
    zsh
  ];

  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
      style = "numbers,header";
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "nord";
      theme_background = false;
    };
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = true;
  };

  programs.zsh.shellAliases = {
    # eza
    "ls" = "eza";
    "ll" = "eza -l";
    "la" = "eza -a";
    "l" = "eza -alh";
    "tree" = "eza -T";
  };

  programs.fzf = {
    enable = true;
    colors = {
      # Nord
      "fg" = "#D8DEE9";
      # "bg" = "#2E3440";
      "hl" = "#A3BE8C";
      "fg+" = "#D8DEE9";
      "bg+" = "#434C5E";
      "hl+" = "#A3BE8C";
      "pointer" = "#BF616A";
      "info" = "#4C566A";
      "spinner" = "#4C566A";
      "header" = "#4C566A";
      "prompt" = "#81A1C1";
      "marker" = "#EBCB8B";
    };
    defaultOptions = [
      "--height 100%"
    ];
  };

  programs.ripgrep.enable = true;

  programs.zoxide.enable = true;
}
