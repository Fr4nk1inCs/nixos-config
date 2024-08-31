{
  config,
  lib,
  ...
}: let
  enable = config.homeManagerConfig.nixvimConfig.type == "full";
  savePath =
    if config.homeManagerConfig.system == "wsl"
    then "/mnt/c/Users/fushen/Pictures/CodeSnap/"
    else "~/Pictures/Codesnap/";
in {
  config = lib.mkIf enable {
    programs.nixvim.plugins.codesnap = {
      enable = true;
      settings = {
        save_path = savePath;
        has_breadcrumbs = true;
        bg_theme = "sea";
        code_font_family = "Maple Mono NF CN";
      };
    };

    programs.nixvim.extraConfigLuaPost = ''
      do
        local codesnap_save_path = vim.fn.expand("${savePath}")
        if vim.fn.isdirectory(codesnap_save_path) == 0 then
          vim.fn.mkdir(codesnap_save_path, "p")
        end
      end
    '';

    programs.nixvim.performance.combinePlugins.standalonePlugins = ["codesnap.nvim"];
  };
}
