{...}: let
  highlights = [
    "TSRainbowRed"
    "TSRainbowYellow"
    "TSRainbowBlue"
    "TSRainbowOrange"
    "TSRainbowGreen"
    "TSRainbowViolet"
    "TSRainbowCyan"
  ];
in {
  programs.nixvim.plugins.indent-blankline = {
    enable = true;

    settings = {
      indent = {
        char = "│";
        tab_char = "│";
      };

      scope.highlight = highlights;

      exclude.filetypes = [
        "help"
        "alpha"
        "dashboard"
        "neo-tree"
        "Trouble"
        "trouble"
        "notify"
        "toggleterm"
        "lazygit"
      ];
    };
  };

  programs.nixvim.extraConfigLuaPre = ''
    -- Configure indent-blankline highlights
    do
      local highlights = {
        "TSRainbowRed",
        "TSRainbowYellow",
        "TSRainbowBlue",
        "TSRainbowOrange",
        "TSRainbowGreen",
        "TSRainbowViolet",
        "TSRainbowCyan",
      }

      local get_hl = function(name)
        local specs = vim.api.nvim_get_hl(0, { name = name })
        local hl = {}
        for k, v in pairs(specs) do
            hl[k] = string.format("#%06x", v)
        end
        return hl
      end

      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        for _, hl in ipairs(highlights) do
            vim.api.nvim_set_hl(0, hl, get_hl(hl))
        end
      end)
    end
  '';

  programs.nixvim.extraConfigLuaPost = ''
    do
      -- Setup indent-blankline scope highlights
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end

    do
      utils.toggle.keymap(
        "<leader>ui",
        "indentation guide",
        function() -- get
          return require("ibl.config").get_config(0).enabled
        end,
        function(state) -- set
          require("ibl").setup_buffer(0, { enabled = state })
        end
      )
    end
  '';
}
