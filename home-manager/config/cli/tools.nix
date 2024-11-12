{pkgs, ...}: {
  home.packages = with pkgs; [
    dust
    fd
    tldr
    wakatime
  ];
  programs = {
    bat = {
      enable = true;
      config = {
        theme = "Nord";
        style = "numbers,header";
      };
    };

    btop = {
      enable = true;
      settings = {
        color_theme = "nord";
        theme_background = false;
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };

    fzf = {
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

    yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    ripgrep.enable = true;

    zoxide.enable = true;

    zsh.shellAliases = {
      # eza
      "ls" = "eza";
      "ll" = "eza -l";
      "la" = "eza -a";
      "l" = "eza -alh";
      "tree" = "eza -T";
      # zoxide
      "cd" = "z";
    };
  };

  # workaround for btop's theme folder
  home.file.".config/btop/themes" = {
    recursive = true;
    source = "${pkgs.btop}/share/btop/themes";
  };
}
