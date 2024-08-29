{
  pkgs,
  config,
  lib,
  ...
}: let
  enable = config.homeManagerConfig.nixvimConfig.type == "full";
  system = config.homeManagerConfig.system;
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
    programs.nixvim.plugins = {
      treesitter.settings.ensure_installed = ["typst"];
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

    programs.nixvim.extraPlugins = [
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

    programs.nixvim.extraConfigLua = ''
      require("typst-preview").setup({
        dependencies_bin = {
          ["typst-preview"] = "tinymist",
          ["websocat"] = "websocat";
        },
        open_cmd = "${openCmd}",
      })
    '';

    programs.nixvim.extraPackages = [pkgs.websocat] ++ openPackages;
  };
}
