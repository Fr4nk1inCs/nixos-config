{ inputs, ... }:
{
  imports = [
    inputs.git-hooks.flakeModule
    inputs.treefmt.flakeModule
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  perSystem = { config, pkgs, ... }: {
    pre-commit = {
      settings.hooks = {
        treefmt.enable = true;
      };
    };

    treefmt = {
      programs = {
        biome = {
          enable = true;
          settings = {
            linter.rules.correctness.noUnknownTypeSelector = "off";
          };
        };
        nixfmt = {
          enable = true;
          width = 80;
        };
        ruff-format = {
          enable = true;
          lineLength = 80;
        };
        deadnix.enable = true;
        statix.enable = true;
        shfmt.enable = true;
        stylua.enable = true;
      };
    };

    devShells.default = pkgs.mkShell {
      inputsFrom = [
        config.pre-commit.devShell
        config.treefmt.build.devShell
      ];

      packages = with pkgs; [
        nix-prefetch-git
        (python3.withPackages (
          ps: with ps; [
            pydantic
            requests
          ]
        ))
      ];
    };
  };
}
