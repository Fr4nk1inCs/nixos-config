{
  pkgs,
  lib,
  ...
}: {
  stylix = lib.mkIf pkgs.stdenv.isDarwin {
    targets.font-packages.enable = false;
    fonts = {
      # NOTE: set all font packages to `maple-mono.NF-CN` as a placeholder.
      # I guess they are never used on Darwin, but the module requires them to
      # be a package.
      sansSerif = {
        name = "SF Pro";
        package = pkgs.maple-mono.NF-CN;
      };
      serif = {
        name = "New York";
        package = pkgs.maple-mono.NF-CN;
      };
      emoji = {
        name = "Apple Color Emoji";
        package = pkgs.maple-mono.NF-CN;
      };
    };
  };
}
