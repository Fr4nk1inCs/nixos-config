{...}: {
  programs.nixvim.extraConfigLuaPre = ''
    utils.notify = function(message, level, opts)
      local level = level or vim.lsp.log_levels.INFO
      local lang = opts.lang or "markdown"
      local opts = {
        title = opts.title or "NixVim Config";
        on_open = function(win)
          vim.wo[win].conceallevel = 3
          vim.wo[win].concealcursor = ""
          vim.wo[win].spell = false
          local buf = vim.api.nvim_win_get_buf(win)
          vim.bo[buf].filetype = lang
          vim.bo[buf].syntax = lang
        end
      }
      vim.notify(message, level, opts)
    end
  '';
}
