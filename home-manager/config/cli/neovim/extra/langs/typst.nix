{
  pkgs,
  config,
  lib,
  ...
}: let
  enable = config.homeManagerConfig.nixvimConfig.type == "full";
  inherit (config.homeManagerConfig) system;
  openCmd =
    {
      wsl = "${pkgs.wsl-open}/bin/wsl-open %s";
      linux = "${pkgs.xdg-utils}/bin/xdg-open %s";
      darwin = "open %s";
    }
    .${system};

  openPackages =
    {
      wsl = [pkgs.wsl-open];
      linux = [pkgs.xdg-utils];
      darwin = [];
    }
    .${system};
in {
  config = lib.mkIf enable {
    programs.nixvim = {
      plugins = {
        treesitter.grammarPackages = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.typst];
        lsp.servers.tinymist = {
          enable = true;
          extraOptions.single_file_support = true;
          settings = {
            exportPdf = "onDocumentHasTitle";
            formatterMode = "typstyle";
            formatterPrintWidth = 80;
          };
        };
      };

      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin {
          name = "typst-preview-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "chomosuke";
            repo = "typst-preview.nvim";
            rev = "7ae2b82cf334819494505b772745beb28705b12b";
            hash = "sha256-kJ6IfLSBmJMgEFuCy6fGtqSRBXjt2Aoxu2NW9iyzRLU=";
          };
        })
      ];

      extraConfigLua = ''
        require("typst-preview").setup({
          dependencies_bin = {
            ["typst-preview"] = "tinymist",
            ["websocat"] = "websocat";
          },
          open_cmd = "${openCmd}",
        })
      '';

      extraPackages = [pkgs.websocat] ++ openPackages;
    };
  };
}
