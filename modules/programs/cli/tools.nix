{
  flake.modules = {
    nixos.cli = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        wget
        curl
      ];
    };

    darwin.cli = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        wget
        curl
      ];
    };

    homeManager.cli = { pkgs, ... }: {
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
          shellWrapperName = "y";
        };

        ripgrep.enable = true;

        zoxide = {
          enable = true;
          options = [
            "--cmd"
            "cd"
          ];
        };
      };

      home = {
        packages = with pkgs; [
          dust
          fd
          tldr
          wakatime-cli

          herdr
        ];

        shellAliases = {
          # eza
          "ls" = "eza";
          "ll" = "eza -l";
          "la" = "eza -a";
          "l" = "eza -alh";
          "tree" = "eza -T";
        };
      };
    };
  };
}
