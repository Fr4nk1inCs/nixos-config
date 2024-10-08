_final: prev: {
  aerospace = prev.callPackage ./aerospace.nix {};
  sogou-pinyin = prev.callPackage ./sogou-pinyin.nix {};
  tencent-meeting = prev.callPackage ./tencent-meeting.nix {};
  fonts = {
    fandol = prev.callPackage ./fonts/fandol.nix {};
    maple-mono = prev.callPackage ./fonts/maple-mono.nix {};
  };
}
