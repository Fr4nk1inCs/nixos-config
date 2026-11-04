{
  flake.modules.darwin.desktop = {
    homebrew.casks = [ "uuremote" ];
  };

  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      moonlight-qt
    ];
  };
}
