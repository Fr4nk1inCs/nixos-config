_: let
  map = keymap: {
    inherit (keymap) key;
    mode = "n";
    inherit (keymap) action;
    options = {
      silent = true;
      inherit (keymap) desc;
    };
  };
  jump = direction: {
    __raw = ''
      function()
        if require("trouble").is_open() then
          require("trouble").${direction}({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.c${direction})
          if not ok then
            utils.notify(err, vim.log.levels.ERROR)
          end
        end
      end
    '';
  };
in {
  programs.nixvim = {
    plugins.trouble = {
      enable = true;
      settings.modes.lsp.win.position = "right";
    };

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>x";
        group = "diagnostics/quickfix";
        icon = {
          icon = "󱖫 ";
          color = "green";
        };
      }
    ];

    keymaps = [
      (map
        {
          key = "<leader>xx";
          action = "<cmd>Trouble diagnostic toggle filter.buf=0<cr>";
          desc = "Buffer diagnostics (Trouble)";
        })
      (map
        {
          key = "<leader>xX";
          action = "<cmd>Trouble diagnostic toggle<cr>";
          desc = "Workspace diagnostics (Trouble)";
        })
      (map
        {
          key = "<leader>cs";
          action = "<cmd>Trouble symbol toggle<cr>";
          desc = "Symbols (Trouble)";
        })
      (map
        {
          key = "<leader>cS";
          action = "<cmd>Trouble lsp toggle<cr>";
          desc = "LSP references/definitions/... (Trouble)";
        })
      (map
        {
          key = "<leader>xL";
          action = "<cmd>Trouble loclist toggle<cr>";
          desc = "Location list (Trouble)";
        })
      (map
        {
          key = "<leader>xQ";
          action = "<cmd>Trouble quickfix toggle<cr>";
          desc = "Quickfix list (Trouble)";
        })
      (map
        {
          key = "[q";
          action = jump "prev";
          desc = "Previous trouble/quickfix item (Trouble)";
        })
      (map
        {
          key = "]q";
          action = jump "next";
          desc = "Next trouble/quickfix item (Trouble)";
        })
    ];
  };
}
