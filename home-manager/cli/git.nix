{pkgs, ...}: {
  home.packages = with pkgs; [
    delta # better diff
    gh # github-cli
    git
    lazygit
  ];

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
