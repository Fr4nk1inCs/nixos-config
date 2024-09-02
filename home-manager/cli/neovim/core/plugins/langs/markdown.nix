{pkgs, ...}: {
  programs.nixvim.plugins = {
    markview = {
      enable = true;
      # FIX: Wait nixpkgs to update markview.nvim
      # Tracking pr: https://github.com/NixOS/nixpkgs/pull/337299
      package = pkgs.vimUtils.buildVimPlugin {
        name = "markview-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "OXY2DEV";
          repo = "markview.nvim";
          rev = "823a3a2f13c6e28e8497641882034901b97ea513";
          sha256 = "0aipxq9h6jlg8n5x5pf1310lfiqm3cmxjpvm57ark6i4p150jyjm";
          fetchSubmodules = true;
        };
      };

      settings = {
        headings = {
          shift_width = 0;
        };

        list_items = {
          indent_size = 2;
          shift_width = 2;
        };
        callbacks.on_enable.__raw = ''
          function(_, window)
            vim.wo[window].conceallevel = 2
          end
        '';
      };
    };

    none-ls.sources.formatting.prettier.enable = true;
    none-ls.sources.diagnostics.markdownlint_cli2.enable = true;
  };
}
