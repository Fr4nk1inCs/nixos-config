{
  pkgs,
  config,
  lib,
  ...
}: let
  enable = config.homeManagerConfig.nixvimConfig.type == "full";

  default =
    {
      wsl = {
        command = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/daipeihust/im-select/master/win-mspy/out/x64/im-select-mspy.exe";
          sha256 = "sha256-FBRkrJXVemB6EY2PBt8UbrLsaENP4xQGPMzl8UKPrpo=";
          executable = true;
        };
        mode = "英语模式";
      };
      darwin = {
        command = pkgs.fetchurl {
          url = "https://github.com/Fr4nk1inCs/macism/releases/download/v1.3.3/macism";
          sha256 = "sha256-wn7Wlh291PpbSrQLWC/fU654suoPHK4/4O7zQ5Z3ldE=";
          executable = true;
        };
        mode = "com.apple.keylayout.ABC";
      };
      linux = {
        command = "fcitx5-remote";
        mode = "keyboard-us";
      };
    }
    .${config.homeManagerConfig.system};
in {
  config = lib.mkIf enable {
    programs.nixvim.extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "im-select-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "keaising";
          repo = "im-select.nvim";
          rev = "6425bea7bbacbdde71538b6d9580c1f7b0a5a010";
          hash = "sha256-sE3ybP3Y+NcdUQWjaqpWSDRacUVbRkeV/fGYdPIjIqg=";
        };
      })
    ];

    programs.nixvim.extraConfigLua = ''
      require("im_select").setup({
        default_command = "${default.command}",
        default_im_select = "${default.mode}",
      })
    '';
  };
}
