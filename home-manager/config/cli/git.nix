{ inputs, ... }: {
  imports = [
    inputs.hunk.homeManagerModules.default
  ];

  programs = {
    gh.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
      signing.format = "openpgp";
      settings = {
        user = {
          name = "Fr4nk1in";
          email = "fushen@mail.ustc.edu.cn";
        };
      };
    };

    hunk = {
      enable = true;
      enableGitIntegration = true;
      settings = {
        theme = "catppuccin-latte";
        mode = "auto";
        line_numbers = true;
        watch = true;
        wrap_lines = true;
        agent_notes = true;
      };
    };

    lazygit = {
      enable = true;

      settings = {
        os.editPreset = "nvim-remote";

        gui = {
          nerdFontsVersion = "3";
        };

        git.pagers = [ { pager = "hunk pager"; } ];
        git.parseEmoji = true;
      };
    };
  };
}
