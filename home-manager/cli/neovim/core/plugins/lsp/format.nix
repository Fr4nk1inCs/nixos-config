_: {
  programs.nixvim.autoGroups = {
    nixvim_format = {clear = true;};
  };

  programs.nixvim.autoCmd = [
    {
      group = "nixvim_format";
      event = ["BufWritePre"];
      callback.__raw = ''
        function(event)
          if vim.b[event.buf].autoformat == nil then
            vim.b[event.buf].autoformat = vim.g.autoformat
          end
          if vim.b[event.buf].autoformat then
            vim.lsp.buf.format({ bufnr = event.buf })
          end
        end
      '';
    }
  ];

  programs.nixvim.keymaps = [
    # Manual format
    {
      action.__raw = ''
        function()
          vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
        end
      '';
      key = "<leader>cf";
      mode = ["n" "v"];
      options = {
        desc = "Format";
        silent = true;
      };
    }
  ];

  programs.nixvim.extraConfigLuaPost = ''
    do -- toggle autoformat keymap
      utils.toggle.keymap(
        "<leader>uf",
        "autoformat (buffer)",
        function() -- get
          local buf = vim.api.nvim_get_current_buf()
          if vim.b[buf].autoformat == nil then
            vim.b[buf].autoformat = vim.g.autoformat
          end

          return vim.b[buf].autoformat
        end,
        function(state) -- set
          local buf = vim.api.nvim_get_current_buf()
          vim.b[buf].autoformat = state
        end,
        function(state) -- notify
          local level = state and vim.log.levels.INFO or vim.log.levels.WARN
          local title = state and "Enabled buffer autoformat" or "Disabled buffer autoformat"

          local global = vim.g.autoformat
          local current = "# Current autoformat status\n" ..
          "- [" .. (global and "x" or " ") .. "] Global **" .. (global and "enabled" or "disabled") .. "**\n" ..
          "- [" .. (state and "x" or " ") .. "] Buffer **" .. (state and "enabled" or "disabled") .. "**"

          utils.notify(current, level, { title = title })
        end
      )
      utils.toggle.keymap(
        "<leader>uF",
        "autoformat (global)",
        function() -- get
          local buf = vim.api.nvim_get_current_buf()
          return vim.g.autoformat
        end,
        function(state) -- set
          vim.g.autoformat = state
          vim.b.autoformat = nil
        end,
        function(state) -- notify
          local level = state and vim.log.levels.INFO or vim.log.levels.WARN
          local title = state and "Enabled global autoformat" or "Disabled global autoformat"

          local current = "# Current autoformat status\n" ..
          "- [" .. (state and "x" or " ") .. "] Global **" .. (state and "enabled" or "disabled") .. "**\n" ..
          "- [" .. (state and "x" or " ") .. "] Buffer **inherit**"

          utils.notify(current, level, { title = title })
        end
      )
    end
  '';
}
