{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      moonlight-qt
      sunshine
    ];
  };
}
