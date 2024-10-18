{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      ultimate-autopair-nvim
    ];

    extraConfigLua = ''
      require('ultimate-autopair').setup({
        {'$', '$', ft = { "typst" }, space = true, newline = true},
        extensions = {
          filetype = {
              nft = { "tex", "plaintex", "latex" },
          },
        },
        tabout = {
          enable = true,
          map = "<tab>",
          cmap = "<tab>",
          hopout = true,
          do_nothing_if_fail = false,
        },
      })
    '';

    plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      latex
      verilog
    ];

    plugins.rainbow-delimiters = {
      enable = true;

      query = {
        default = "rainbow-delimiters";
        lua = "rainbow-blocks";
        latex = "rainbow-blocks";
        verilog = "rainbow-blocks";
        query = "rainbow-blocks";
      };

      highlight = [
        "TSRainbowRed"
        "TSRainbowYellow"
        "TSRainbowBlue"
        "TSRainbowOrange"
        "TSRainbowGreen"
        "TSRainbowViolet"
        "TSRainbowCyan"
      ];
    };
  };
}
