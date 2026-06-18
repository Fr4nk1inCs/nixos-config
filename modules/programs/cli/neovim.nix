{ inputs, ... }: {
  flake.modules = {
    nixos.cli = {
      imports = [
        inputs.nixCats.nixosModule
      ];

      environment = {
        shellAliases = {
          "vimdiff" = "nvim -d";
          "v" = "nvim";
        };

        variables = {
          EDITOR = "nvim";
        };
      };

      nvim.enable = true;
    };

    darwin.cli = { pkgs, ... }: {
      environment = {
        shellAliases = {
          "vimdiff" = "nvim -d";
        };

        variables = {
          EDITOR = "nvim";
        };

        systemPackages = [
          inputs.nixCats.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
    };

    homeManager.cli = {
      imports = [
        inputs.nixCats.homeModule
      ];

      home = {
        shellAliases = {
          "vimdiff" = "nvim -d";
          "v" = "nvim";
        };

        sessionVariables = {
          EDITOR = "nvim";
        };
      };

      nvim = {
        enable = true;
        packageNames = [ "nvim" ];
      };
    };
  };
}
