{...}: {
  programs.nixvim.plugins.lualine = {
    enable = true;

    globalstatus = true;
    theme = "auto";
    disabledFiletypes.statusline = ["dashboard"];
    extensions = ["neo-tree" "fzf" "toggleterm" "man"];

    sections = {
      lualine_a = [
        {
          name = "mode";
          icon = "";
          fmt.__raw = ''
            function(text)
              return text:sub(1, 1):upper()
            end
          '';
        }
      ];
      lualine_b = [
        {
          name = "branch";
        }
        {
          name = "diff";
          extraConfig = {
            symbols = {
              added.__raw = "utils.icons.git.added";
              modified.__raw = "utils.icons.git.modified";
              removed.__raw = "utils.icons.git.removed";
            };
            source.__raw = ''
              function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end
            '';
          };
        }
      ];
      lualine_c = [
        {
          name.__raw = "utils.lualine.root_dir().name";
          extraConfig = {
            cond.__raw = "utils.lualine.root_dir().cond";
            color.__raw = "utils.lualine.root_dir().color";
          };
        }
        {
          name = "diagnostics";
          extraConfig.symbols = {
            error.__raw = "utils.icons.diagnostics.error";
            warn.__raw = "utils.icons.diagnostics.warn";
            info.__raw = "utils.icons.diagnostics.info";
            hint.__raw = "utils.icons.diagnostics.hint";
          };
        }
        {
          name = "filetype";
          extraConfig = {
            icon_only = true;
          };
          separator = {
            left = "";
            right = "";
          };
          padding = {
            left = 1;
            right = 0;
          };
        }
        {
          name.__raw = "utils.lualine.pretty_path()";
        }
        {
          name.__raw = ''
            utils.lualine.trouble.name
          '';
          extraConfig.cond.__raw = ''
            utils.lualine.trouble.cond
          '';
        }
      ];

      lualine_x = [
        {
          name.__raw = ''
            function()
              return require("noice").api.status.command.get()
            end
          '';
          extraConfig = {
            cond.__raw = ''
              function()
                return require("noice").api.status.command.has()
              end
            '';
            color = "Statement";
          };
        }
        {
          name.__raw = ''
            function()
              return require("noice").api.status.mode.get()
            end
          '';
          extraConfig = {
            cond.__raw = ''
              function()
                return require("noice").api.status.mode.has()
              end
            '';
            color = "Constant";
          };
        }
        {
          name.__raw = ''
            function()
              return  "  " .. require("dap").status()
            end
          '';
          extraConfig = {
            cond.__raw = ''
              function()
                return require("dap").status() ~= ""
              end
            '';
            color = "Debug";
          };
        }
      ];
      lualine_y = [
        {
          name = "fileformat";
          separator.left = "";
        }
        {
          name = "encoding";
          separator.left = "";
        }
        {
          name = "filesize";
        }
      ];
      lualine_z = [
        {
          name = "progress";
          padding = {
            left = 1;
            right = 1;
          };
        }
        {
          name = "location";
          separator.left = " ";
          padding = {
            left = 0;
            right = 0;
          };
        }
      ];
    };
  };
}
