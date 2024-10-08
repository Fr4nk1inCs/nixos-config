_final: prev: {
  aerospace = prev.callPackage ./aerospace.nix {};
  sogou-pinyin-mac = prev.callPackage ./sogou-pinyin-mac.nix {};
  notion-for-apple-silicon = prev.callPackage ./notion-for-apple-silicon.nix {};
  tencent-meeting = prev.callPackage ./tencent-meeting.nix {};
  fonts = {
    fandol = prev.callPackage ./fonts/fandol.nix {};
    maple-mono = prev.callPackage ./fonts/maple-mono.nix {};
  };
}
