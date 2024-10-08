{...}: {
  imports = [
    ../default.nix
  ];

  homeManagerConfig = {
    username = "fr4nk1in";
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
