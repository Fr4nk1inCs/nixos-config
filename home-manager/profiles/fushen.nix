{...}: {
  imports = [
    ../default.nix
  ];

  homeManagerConfig = {
    username = "fushen";
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
