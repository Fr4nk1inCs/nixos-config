_final: prev: {
  sogou-pinyin = prev.callPackage ./sogou-pinyin.nix {};
  tencent-meeting = prev.callPackage ./tencent-meeting.nix {};
  fira-math = prev.callPackage ./fonts/fira-math.nix {};
  fonts = {
    fandol = prev.callPackage ./fonts/fandol.nix {};
    maple-mono = prev.callPackage ./fonts/maple-mono.nix {};
  };
}
