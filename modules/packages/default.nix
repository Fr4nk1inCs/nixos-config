_inputs: _final: prev: {
  fandol-fonts = prev.callPackage ./fonts/fandol.nix { };
  misans = prev.callPackage ./fonts/misans.nix { };
}
