{pkgs, ...}: {
  programs = {
    bat = {
      enable = true;
      config = {
        style = "numbers,header";
      };
    };

    btop = {
      enable = true;
      settings = {
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
      defaultOptions = [
        "--height=~100%"
      ];
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    ripgrep.enable = true;

    zoxide.enable = true;
  };

  home = {
    packages = with pkgs; [
      dust
      fd
      tldr
      wakatime-cli
      # cli coding agents
      github-copilot-cli
      gemini-cli
    ];

    shellAliases = {
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
}
