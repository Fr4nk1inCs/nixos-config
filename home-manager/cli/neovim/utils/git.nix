{...}: {
  programs.nixvim.extraConfigLuaPre = ''
    utils.git = {};

    utils.git.lazygit = function(opts)
      local cwd = {}
      if opts.cwd ~= nil then
        cwd = { "--path", opts.cwd }
      end

      local args = vim.list_extend({ "lazygit" }, opts.args or {})
      args = vim.list_extend(args, cwd)
      local cmd = table.concat(args, " ")

      local term = require("toggleterm.terminal").Terminal
      local lazygit = term:new({
        cmd = cmd,
        hidden = false,
        close_on_exit = true,
        on_open = function(term)
          vim.cmd("startinsert!")
          -- set buffer filetype to lazygit
          vim.bo[term.bufnr].filetype = "lazygit"
          -- disable `<esc><esc>`
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc><esc>", "", { noremap = true, silent = true });
        end,
      })
      lazygit:toggle()
    end

    utils.git.blame_line = function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local line = cursor[1]
      local file = vim.api.nvim_buf_get_name(0)
      local root = utils.root.detectors.pattern(0, { ".git" })[1] or "."
      local cmd = "git -C " .. root .. " log -n 3 -u -L " .. line .. ",+1:" .. file
      local term = require("toggleterm.terminal").Terminal:new({
        cmd = cmd,
        hidden = false,
        float_opts = {
          height = function(_) return math.floor(vim.o.lines * 0.5) end,
          width = function(_) return math.floor(vim.o.columns * 0.5) end,
        },
        on_open = function(term)
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
        close_on_exit = false,
      })
      term:toggle()
    end
  '';
}
