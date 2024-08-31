{...}: {
  imports = [
    ./utils
    ./core
    ./extra
  ];

  programs.nixvim = {
    enable = true;

    enableMan = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withRuby = true;

    # performance = {
    #   byteCompileLua = {
    #     enable = true;
    #     nvimRuntime = true;
    #     plugins = true;
    #   };
    #   combinePlugins = {
    #     enable = true;
    #     standalonePlugins = ["nvim-treesitter"];
    #   };
    # };
  };

  programs.zsh.shellAliases = {
    "v" = "nvim";
  };
}
