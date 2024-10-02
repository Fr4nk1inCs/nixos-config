{...}: {
  imports = [
    ../default.nix
  ];

  homeManagerConfig = {
    username = "fr4nk1in";
    system = "darwin";
    gui.enable = true;
    extraProgramConfig = {
      zsh.initExtra = ''
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
    };
  };
}
