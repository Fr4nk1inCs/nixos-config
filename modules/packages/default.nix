_final: prev: {
  tencent-meeting = prev.callPackage ./tencent-meeting.nix {};
  fira-math = prev.callPackage ./fonts/fira-math.nix {};
  fonts = {
    fandol = prev.callPackage ./fonts/fandol.nix {};
  };
}
