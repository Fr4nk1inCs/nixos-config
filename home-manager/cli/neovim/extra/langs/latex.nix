{
  config,
  lib,
  ...
}: let
  enable = config.homeManagerConfig.nixvimConfig.type == "full";
  inherit (config.homeManagerConfig) system;
  forwardSearchAfter = system != "wsl"; # Avoid focus being taken by the PDF viewer
  forwardSearch = {
    wsl = {
      executable = "/mnt/c/Users/fushen/AppData/Local/SumatraPDF/SumatraPDF.exe";
      args = [
        "-reuse-instance"
        "%p"
        "-forward-search"
        "%f"
        "%l"
      ];
    };
    linux = {
      executable = "zathura";
      args = [
        "--synctex-forward"
        "%l:1:%f"
        "%p"
      ];
    };
    darwin = {
      executable = "open";
      args = [
        "-a"
        "/Applications/Skim.app"
        "-r"
        "%l"
        "%p"
        "%f"
      ];
    };
  };
in {
  config.programs.nixvim.plugins.lsp.servers.texlab = lib.mkIf enable {
    enable = true;
    settings.texlab = {
      build = {
        executable = "xelatex";
        args = [
          "-shell-escape"
          "-synctex=1"
          "-interaction=nonstopmode"
          "%f"
        ];
        onSave = true;
        inherit forwardSearchAfter;
      };
      inherit forwardSearch;
      chktex = {
        onOpenAndSave = true;
        onEdit = true;
      };
    };
  };
}
