{pkgs, ...}: {
  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    ts-comments-nvim
  ];
  programs.nixvim.extraConfigLua = ''
    require('ts-comments').setup()
  '';
}
