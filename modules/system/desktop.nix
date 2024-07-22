# TODO: Desktop configuration
{pkgs, ...}: {
  users.defaultUserShell = pkgs.zsh;

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [fcitx5-rime];
      waylandFrontend = true;
    };
  };

  programs.clash-verge = {
    enable = true;
    tunMode = true;
    package = pkgs.clash-verge-rev;
  };
}
