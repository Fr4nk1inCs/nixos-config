{pkgs, ...}: {
  programs.nixvim.plugins = {
    lsp.servers.lua-ls = {
      enable = true;
      settings.Lua = {
        workspace = {
          checkThirdParty = false;
        };
        codeLens = {
          enable = true;
        };
        completion = {
          callSnippet = "Replace";
        };
        doc = {
          privateName = ["^_"];
        };
        hint = {
          enable = true;
          setType = false;
          paramType = true;
          paramName = "Disable";
          semicolon = "Disable";
          arrayIndex = "Disable";
        };
      };
    };

    conform-nvim.settings.formatters_by_ft = {lua = ["stylua"];};
  };

  programs.nixvim.extraPackages = with pkgs; [stylua];
}
