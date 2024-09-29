{
  pkgs,
  config,
  lib,
  ...
}: let
  enable = config.homeManagerConfig.nixvimConfig.type == "full";
  im-select-mspy = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/daipeihust/im-select/master/win-mspy/out/x64/im-select-mspy.exe";
    sha256 = "sha256-FBRkrJXVemB6EY2PBt8UbrLsaENP4xQGPMzl8UKPrpo=";
    executable = true;
  };
  im-select-macos = pkgs.fetchurl {
    url = "https://github.com/daipeihust/im-select/raw/master/macOS/out/apple/im-select";
    sha256 = "sha256-GTEp9Qp0MiZdFn7hYXN76dsR/zYuuaPDBtf7UwuyvVo=";
    executable = true;
  };
  default =
    {
      wsl = {
        command = "${im-select-mspy}";
        mode = "英语模式";
      };
      darwin = {
        command = "${im-select-macos}";
        mode = "com.apple.keylayout.US";
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
