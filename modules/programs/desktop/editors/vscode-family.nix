{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        (if stdenv.isLinux then vscode-fhs else vscode)
      ];
    };
}
