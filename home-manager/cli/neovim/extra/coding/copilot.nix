{
  lib,
  config,
  ...
}: let
  enable = config.homeManagerConfig.nixvimConfig.type == "full";
in {
  config.programs.nixvim.plugins = lib.mkIf enable {
    copilot-lua = {
      enable = true;

      filetypes = {
        markdown = true;
        help = true;
      };

      suggestion.enabled = false;
      panel.enabled = false;
    };

    cmp.settings.sources = [
      {
        name = "copilot";
      }
    ];

    lualine.sections.lualine_x = [
      {
        name.__raw = ''
          function()
            local status = require("copilot.api").status.data
            local icon = utils.icons.kinds.Copilot
            return icon .. (status.message or "")
          end
        '';
        extraConfig = {
          cond.__raw = ''
            function()
              local clients = vim.lsp.get_clients({ name = "copilot", bufnr = 0 })
              return #clients > 0
            end
          '';
          color.__raw = ''
            function()
              local status = require("copilot.api").status.data.status
              if status == "Warning" then
                return "DiagnosticError"
              elseif status == "InProgress" then
                return "DiagnosticWarn"
              end
              return "Special"
            end
          '';
        };
      }
    ];
  };
}
