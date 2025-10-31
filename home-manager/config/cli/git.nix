_: {
  programs = {
    gh.enable = true;
    glab.enable = true;

    git = {
      enable = true;
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
        light = false;
        side-by-side = false;
      };
    };

    lazygit = {
      enable = true;

      settings = {
        os.editPreset = "nvim-remote";

        gui = {
          nerdFontsVersion = "3";
          theme = {
            unstagedChangesColor = ["#bf616a"];
            selectedLineBgColor = ["#3e4a5b"];
            searchingActiveBorderColor = ["#ebcb8b" "bold"];
            optionsTextColor = ["#8cafd2"];
            inactiveBorderColor = ["#7e8188"];
            defaultFgColor = ["#cdcecf"];
            cherryPickedCommitFgColor = ["#8cafd2"];
            cherryPickedCommitBgColor = ["#88c0d0"];
            activeBorderColor = ["#ebcb8b" "bold"];
          };
        };

        git.paging.pager = "delta --dark --paging=never";

        parseEmoji = true;
      };
    };
  };
}
