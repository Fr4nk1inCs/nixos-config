{...}: {
  imports = [
    ./icons.nix
    ./notify.nix
    ./ui.nix
    ./root.nix
    ./git.nix
    ./toggle.nix
    ./lualine.nix
  ];

  programs.nixvim.extraConfigLuaPre = ''
    local utils = {}

    utils.norm = function(path)
      if path:sub(1, 1) == "~" then
        local home = vim.uv.os_homedir()
        if home:sub(-1) == "\\" or home:sub(-1) == "/" then
          home = home:sub(1, -2)
        end
        path = home .. path:sub(2)
      end
      path = path:gsub("\\", "/"):gsub("/+", "/")
      return path:sub(-1) == "/" and path:sub(1, -2) or path
    end
  '';
}
