{...}: let
  augroup = name: "nixvim_${name}";
  createAutoGroups = groups:
    builtins.listToAttrs (
      builtins.map
      (group: {
        name = group;
        value = {clear = true;};
      })
      groups
    );
in rec {
  programs.nixvim.autoGroups = createAutoGroups (
    builtins.map (cmd: cmd.group) programs.nixvim.autoCmd
  );

  programs.nixvim.autoCmd = [
    {
      # Check if we need to reload the file when it changed
      group = augroup "checktime";
      event = ["FocusGained" "TermClose" "TermLeave"];
      callback.__raw = "
      function()
        if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
      end";
    }
    {
      # Highlight on yank
      group = augroup "highlight_yank";
      event = ["TextYankPost"];
      callback.__raw = "function() vim.highlight.on_yank() end";
    }
    {
      # Resize splits if window got resized
      group = augroup "resize_splits";
      event = ["VimResized"];
      callback.__raw = "
        function()
          local current_tab = vim.fn.tabpagenr()
          vim.cmd('tabdo wincmd =')
          vim.cmd('tabnext ' .. current_tab)
        end";
    }
    {
      # Go to last loc when opening a buffer
      group = augroup "last_loc";
      event = ["BufReadPost"];
      callback.__raw = ''
        function(event)
          local exclude = { "gitcommit" }
          local buf = event.buf
          if vim.tbl_contains(exclude, vim.bo[buf].filetype) or
             vim.b[buf].nixvim_last_loc then
            return
          end
          vim.b[buf].nixvim_last_loc = true
          local mark = vim.api.nvim_buf_get_mark(buf, '"')
          local lcount = vim.api.nvim_buf_line_count(buf)
          if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end
      '';
    }
    {
      # Close some filetypes with `q`
      group = augroup "close_with_q";
      event = ["FileType"];
      pattern = [
        "PlenaryTestPopup"
        "grug-far"
        "help"
        "lspinfo"
        "notify"
        "qf"
        "spectre_panel"
        "startuptime"
        "tsplayground"
        "neotest-output"
        "checkhealth"
        "neotest-summary"
        "neotest-output-panel"
        "dbout"
        "gitsigns.blame"
      ];
      callback.__raw = ''
        function(event)
          vim.bo[event.buf].buflisted = false
          vim.keymap.set("n", "q", "<cmd>close<cr>", {
            buffer = event.buf,
            silent = true,
            desc = "Quit buffer",
          })
        end
      '';
    }
    {
      # Make it easier to close man-files when opened inline
      group = augroup "man_unlisted";
      pattern = ["man"];
      event = ["FileType"];
      callback.__raw = ''
        function(event)
          vim.bo[event.buf].buflisted = false
        end
      '';
    }
    {
      # Wrap in text filetypes
      group = augroup "wrap";
      event = ["FileType"];
      pattern = [
        "text"
        "tex"
        "plaintex"
        "typst"
        "gitcommit"
        "markdown"
      ];
      callback.__raw = ''
        function()
          vim.opt_local.wrap = true
        end
      '';
    }
    {
      # Fix conceallevel for JSON files
      group = augroup "json_conceal";
      event = ["FileType"];
      pattern = ["json" "jsonc" "json5"];
      command = "setlocal conceallevel=0";
    }
    {
      group = augroup "auto_create_dir";
      event = ["BufWritePre"];
      callback.__raw = ''
        function(event)
          if event.match:match("^%w%w+:[\\/][\\/]") then
            return
          end
          local file = vim.uv.fs_realpath(event.match) or event.match
          vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        end
      '';
    }
    {
      group = augroup "bigfile";
      event = ["FileType"];
      pattern = ["bigfile"];
      callback.__raw = ''
        function(ev)
          vim.b.minianimate_disable = true
          vim.schedule(function()
            vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ""
          end)
        end
      '';
    }
  ];
}
