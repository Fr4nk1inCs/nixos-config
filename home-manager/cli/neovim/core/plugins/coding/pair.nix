{pkgs, ...}: {
  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    ultimate-autopair-nvim
  ];

  programs.nixvim.extraConfigLua = ''
    require('ultimate-autopair').setup({
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

  programs.nixvim.plugins.treesitter.settings.ensure_installed = [
    "latex"
    "verilog"
  ];

  programs.nixvim.plugins.rainbow-delimiters = {
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
}
