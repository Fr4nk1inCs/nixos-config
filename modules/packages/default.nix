_final: prev: {
  aerospace = prev.callPackage ./aerospace.nix {};
  sogou-pinyin-mac = prev.callPackage ./sogou-pinyin-mac.nix {};
  fonts = {
    fandol = prev.callPackage ./fonts/fandol.nix {};
    maple-mono = prev.callPackage ./fonts/maple-mono.nix {};
  };
}
