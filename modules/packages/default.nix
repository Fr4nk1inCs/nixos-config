_final: prev: {
  fonts = {
    fandol = prev.callPackage ./fonts/fandol.nix {};
    fira-math = prev.callPackage ./fonts/fira-math.nix {};
    misans = prev.callPackage ./fonts/misans.nix {};
  };

  whitesur-gtk-theme-libadwaita-patch = prev.whitesur-gtk-theme.overrideAttrs (_: prev: {
    pname = "whitesur-gtk-theme-libadwaita-patch";
    postPatch =
      prev.postPatch
      + ''
        substituteInPlace libs/lib-install.sh --replace-fail '"''${HOME}/.config/gtk-4.0"' '"$out/config/gtk-4.0"'
        substituteInPlace install.sh --replace-fail '"''${libadwaita}"' '"true"'
        substituteInPlace install.sh --replace-fail '"$UID"' '"1"'
      '';
  });

  ice-bar = prev.ice-bar.overrideAttrs {
    version = "0.11.13-2f-unofficial";

    src = prev.fetchurl {
      url = "https://github.com/user-attachments/files/24838544/Ice.zip";
      hash = "sha256-pkcnhfYl6Bs/wX6Z5yK1cGCENeQ+/SgwgcDEFIhXoxM=";
    };
  };
}
