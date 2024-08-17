{...}: {
  programs.nixvim.filetype = {
    extension = {
      tex = "tex";
    };
    pattern = {
      ".*".__raw = ''
        function(path, buf)
          return vim.bo[buf]
              and vim.bo[buf].filetype ~= "bigfile"
              and path
              and vim.fn.getfsize(path) > vim.g.bigfile_size
              and "bigfile"
            or nil
        end
      '';
    };
  };
}
