_: {
  programs = {
    gh.enable = true;

    git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          navigate = true;
          light = false;
          side-by-side = false;
        };
      };
      userEmail = "fushen@mail.ustc.edu.cn";
      userName = "Fr4nk1in";
      extraConfig.credential.helper = "store";
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
