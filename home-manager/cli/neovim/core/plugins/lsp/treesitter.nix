_: {
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;

      folding = true;
      nixvimInjections = true;

      settings = {
        highlight.enable = true;
        indent.enable = true;
        ensure_installed = [
          "bash"
          "c"
          "diff"
          "html"
          "javascript"
          "jsdoc"
          "json"
          "jsonc"
          "lua"
          "luadoc"
          "luap"
          "markdown"
          "markdown_inline"
          "printf"
          "python"
          "query"
          "regex"
          "toml"
          "tsx"
          "typescript"
          "vim"
          "vimdoc"
          "xml"
          "yaml"
        ];
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<c-space>";
            node_incremental = "<c-space>";
            scope_incremental = false;
            node_decremental = "<bs>";
          };
        };
      };
    };

    treesitter-textobjects = {
      enable = true;
      move = {
        enable = true;
        gotoNextStart = {
          "]f" = "@function.outer";
          "]c" = "@class.outer";
          "]a" = "@parameter.inner";
        };
        gotoNextEnd = {
          "]F" = "@function.outer";
          "]C" = "@class.outer";
          "]A" = "@parameter.inner";
        };
        gotoPreviousStart = {
          "[f" = "@function.outer";
          "[c" = "@class.outer";
          "[a" = "@parameter.inner";
        };
        gotoPreviousEnd = {
          "[F" = "@function.outer";
          "[C" = "@class.outer";
          "[A" = "@parameter.inner";
        };
      };
    };

    ts-autotag.enable = true;

    treesitter-context = {
      enable = true;
      settings = {
        mode = "cursor";
        max_lines = 3;
      };
    };
  };

  programs.nixvim.highlight = {
    TreesitterContextBottom = {
      underline = true;
    };
  };

  programs.nixvim.extraConfigLuaPost = ''
    do
      local tsc = require("treesitter-context")

      utils.toggle.keymap(
        "<leader>uT",
        "treesitter highlight",
        function() -- get
          return vim.b.ts_highlight
        end,
        function(state) -- set
          if state then
            vim.treesitter.start()
          else
            vim.treesitter.stop()
          end
        end
      )

      utils.toggle.keymap(
        "<leader>ut",
        "treesitter context",
        tsc.enabled, -- get
        function(state) -- set
          if state then
            tsc.enable()
          else
            tsc.disable()
          end
        end
      )
    end
  '';
}
