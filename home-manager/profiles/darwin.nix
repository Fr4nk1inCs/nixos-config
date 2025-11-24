{
  home.username = "fr4nk1in";
  programs.zsh.initContent = ''
    function ssh() {
      case $TERM in
        *kitty*)
          kitty +kitten ssh "$@"
          ;;
        *)
          command ssh "$@"
          ;;
      esac
    }
  '';

  profile.guiSoftwares.enable = true;
  profile.windowManager.enable = true;
}
