inputs: _final: prev: {
  fonts = {
    fandol = prev.callPackage ./fonts/fandol.nix {};
    fira-math = prev.callPackage ./fonts/fira-math.nix {};
    misans = prev.callPackage ./fonts/misans.nix {};
  };

  whitesur-gtk-theme-libadwaita-patch = prev.whitesur-gtk-theme.overrideAttrs (_: prevAttrs: {
    pname = "whitesur-gtk-theme-libadwaita-patch";
    postPatch =
      prevAttrs.postPatch
      + ''
        substituteInPlace libs/lib-install.sh --replace-fail '"''${HOME}/.config/gtk-4.0"' '"$out/config/gtk-4.0"'
        substituteInPlace install.sh --replace-fail '"''${libadwaita}"' '"true"'
        substituteInPlace install.sh --replace-fail '"$UID"' '"1"'
      '';
  });
}
