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
in {
  config = lib.mkIf enable {
    programs.nixvim = {
      plugins = {
        # treesitter.grammarPackages = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.typst];
        lsp.servers.tinymist = {
          enable = true;
          extraOptions = {
            single_file_support = true;
          };
          settings = {
            exportPdf = "onDocumentHasTitle";
            semanticTokens = "disable";
            formatterMode = "disable";
            compileStatus = "disable";
          };
        };
        typst-vim.enable = true;
        none-ls.sources.formatting.typstyle.enable = true;
      };

      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin {
          name = "typst-preview-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "chomosuke";
            repo = "typst-preview.nvim";
            rev = "0f43ed7fa661617751bfd0ca2f01ee13eba6569e";
            hash = "sha256-olO2hh2xU/tiuwMNKGuKU+Wa5taiTUOv9jlK2/99yvk=";
          };
        })
      ];

      extraConfigLua = ''
        require("typst-preview").setup({
          dependencies_bin = {
            ["tinymist"] = "${pkgs.tinymist}/bin/tinymist",
            ["websocat"] = "${pkgs.websocat}/bin/websocat";
          },
          open_cmd = "${openCmd}",
          get_root = function(path)
            return require("lspconfig.util").find_git_ancestor(path) or path
          end,
        })
      '';
    };
  };
}
