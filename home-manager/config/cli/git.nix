{config, ...}: {
  config.programs = {
    gh.enable = true;
    # glab.enable = true;

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

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        light = config.stylix.polarity == "light";
        side-by-side = false;
        # line numbers
        line-numbers = true;
        line-numbers-minus-style = "red";
        line-numbers-plus-style = "green";
      };
    };

    lazygit = {
      enable = true;

      settings = {
        os.editPreset = "nvim-remote";

        gui = {
          nerdFontsVersion = "3";
        };

        git.pagers = [{pager = "delta --paging=never";}];

        parseEmoji = true;
      };
    };
  };
}
