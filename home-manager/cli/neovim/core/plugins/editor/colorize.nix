{...}: {
  programs.nixvim.plugins.nvim-colorizer = {
    enable = true;
    userDefaultOptions = {
      RGB = true;
      RRGGBB = true;
      mode = "virtualtext";
    };
    fileTypes = [
      {
        language = ''["*"]'';
      }
      {
        language = "css";
        css = true;
      }
      {
        language = "sass";
        css = true;
        sass.enable = true;
      }
      {
        language = "html";
        css = true;
        tailwind = true;
      }
    ];
  };
}
