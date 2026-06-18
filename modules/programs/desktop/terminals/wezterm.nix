{ self, ... }: {
  flake.modules.homeManager.desktop =
    { pkgs, lib, ... }:
    let
      inherit (self.lib.fontFeatures) toKeyValues;
      renderFrontend = if pkgs.stdenv.isDarwin then "WebGpu" else "OpenGL";
      fontFeatures = self.constants.fontFeatures.maple-mono;
      fontFeaturesLiterals = map (s: ''"${s}"'') (toKeyValues fontFeatures);
      fontFeaturesLuaInner = lib.concatStringsSep ", " fontFeaturesLiterals;
    in
    {
      programs.wezterm.extraConfig = ''
        config.front_end = ${renderFrontend}

        local font_features = { ${fontFeaturesLuaInner} };

        ${builtins.readFile ./wezterm.lua}
      '';

    };
}
