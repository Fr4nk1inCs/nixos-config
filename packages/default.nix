_final: prev: {
  fandol-fonts = prev.callPackage ./fonts/fandol.nix { };
  harmonyos-sans = prev.callPackage ./fonts/harmonyos-sans.nix { };
  lxgw-neozhisong-plus = prev.callPackage ./fonts/lxgw-neozhisong-plus.nix { };
  vscode-extensions = {
    meta.pyrefly = prev.callPackage ./vscode/pyrefly.nix { };
  }
  // prev.vscode-extensions;
}
