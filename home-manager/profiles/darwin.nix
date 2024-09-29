{...}: {
  imports = [
    ../default.nix
  ];

  homeManagerConfig = {
    username = "fushen";
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
