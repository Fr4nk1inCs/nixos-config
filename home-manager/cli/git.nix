{...}: {
  programs.gh.enable = true;

  programs.git = {
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

  programs.lazygit.enable = true;
}
