_: {
  programs.nixvim.plugins = {
    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add.text = "▎";
          change.text = "▎";
          delete.text = "";
          topdelete.text = "";
          changedelete.text = "▎";
          untracked.text = "▎";
        };
        signs_staged = {
          add.text = "▎";
          change.text = "▎";
          delete.text = "";
          topdelete.text = "";
          changedelete.text = "▎";
        };
        preview_config.border = "rounded";
        on_attach.__raw = ''
          function(buffer)
            local gs = require("gitsigns")

            local function map(mode, l, r, desc)
              vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

            -- stylua: ignore start
            map("n", "]h", function()
              if vim.wo.diff then
                vim.cmd.normal({ "]c", bang = true })
              else
                gs.nav_hunk("next")
              end
            end, "Next Hunk")
            map("n", "[h", function()
              if vim.wo.diff then
                vim.cmd.normal({ "[c", bang = true })
              else
                gs.nav_hunk("prev")
              end
            end, "Prev Hunk")
            map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
            map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
            map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
            map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
            map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
            map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
            map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
            map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
            map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
            map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
            map("n", "<leader>ghd", gs.diffthis, "Diff This")
            map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
          end
        '';
      };
    };

    which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>g";
        group = "Git";
      }
      {
        __unkeyed-1 = "<leader>gh";
        group = "Git Hunk";
      }
    ];

    which-key.settings.disable.ft = ["lazygit"];
  };

  programs.nixvim.keymaps = [
    {
      key = "<leader>gg";
      action.__raw = "function() utils.git.lazygit({ cwd = utils.root.git() }) end";
      mode = "n";
      options = {
        desc = "Lazygit (root)";
        silent = true;
      };
    }
    {
      key = "<leader>gG";
      action.__raw = "function() utils.git.lazygit() end";
      mode = "n";
      options = {
        desc = "Lazygit (cwd)";
        silent = true;
      };
    }
    {
      key = "<leader>gl";
      action.__raw = ''
        function()
          utils.git.lazygit({ args = { "log" }, cwd = utils.root.git() })
        end
      '';
      mode = "n";
      options = {
        desc = "Lazygit log (root)";
        silent = true;
      };
    }
    {
      key = "<leader>gL";
      action.__raw = ''
        function()
          utils.git.lazygit({ args = { "log" } })
        end
      '';
      mode = "n";
      options = {
        desc = "Lazygit log (cwd)";
        silent = true;
      };
    }
    {
      key = "<leader>gf";
      action.__raw = ''
        function()
          local git_path = vim.api.nvim_buf_get_name(0)
          utils.git.lazygit({ args = { "-f", git_path } })
        end
      '';
      mode = "n";
      options = {
        desc = "Lazygit current file history";
        silent = true;
      };
    }
    {
      key = "<leader>gb";
      action.__raw = "function() utils.git.blame_line() end";
      mode = "n";
      options = {
        desc = "Blame line";
        silent = true;
      };
    }
  ];
}
