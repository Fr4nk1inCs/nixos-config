{
  lib,
  config,
  ...
}: let
  enable = config.homeManagerConfig.nixvimConfig.type == "full";
in {
  config = lib.mkIf enable {
    programs.nixvim.plugins = {
      copilot-lua = {
        enable = true;

        filetypes = {
          markdown = true;
          help = true;
        };

        suggestion = {
          enabled = true;
          keymap = {
            accept = "<c-a>";
            prev = "<c-[>";
            next = "<c-]>";

            dismiss = "<c-q>";
          };
        };
      };

      lualine.settings.sections.lualine_x = [
        {
          __unkeyed-1.__raw = ''
            function()
              local status = require("copilot.api").status.data
              local icon = utils.icons.kinds.Copilot
              return icon .. (status.message or "")
            end
          '';
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
        }
      ];
    };

    programs.nixvim.performance.combinePlugins.standalonePlugins = ["copilot.lua"];
  };
}
