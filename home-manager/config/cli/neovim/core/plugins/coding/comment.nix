_: {
  programs.nixvim.plugins.ts-comments = {
    enable = true;
    settings.lang = {
      typst = "// %s";
    };
  };
}
