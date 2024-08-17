{...}: let
  roundedBorder = {__raw = "cmp.config.window.bordered()";};
in {
  programs.nixvim.extraConfigLuaPre = ''
    local __cmp_cmdline_border = require("cmp").config.window.bordered();
    __cmp_cmdline_border.border = {
      "┬", "─", "┬", "│", "╯", "─", "╰", "│"
    }
    __cmp_cmdline_border.winhighlight = "Normal:Normal,FloatBorder:NoiceCmdlinePopupBorder,CursorLine:Visual,Search:None";
  '';
  programs.nixvim.plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        completion.completeopt = "menu,menuone,noinsert,noselect";
        preselect = "cmp.PreselectMode.None";

        mapping = {
          "<c-space>" = "cmp.mapping.complete()";
          "<c-b>" = "cmp.mapping.scroll_docs(-4)";
          "<c-f>" = "cmp.mapping.scroll_docs(4)";
          "<c-k>" = "cmp.mapping.close()";
          "<cr>" = ''
            cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = false,
            })
          '';
          "<s-tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };

        sources = [
          {
            name = "nvim_lsp";
          }
          {
            name = "luasnip";
          }
          {
            name = "path";
          }
          {
            name = "buffer";
          }
        ];

        window = {
          completion = roundedBorder;
          documentation = roundedBorder;
        };

        formatting.format.__raw = ''
          function(entry, item)
            local icons = utils.icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end

            local widths = {
              abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
              menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
            }

            for key, width in pairs(widths) do
              if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
              end
            end

            return item
          end
        '';
      };

      cmdline = {
        "/" = {
          mapping = {
            __raw = "cmp.mapping.preset.cmdline()";
          };
          sources = [
            {
              name = "buffer";
            }
          ];
        };
        ":" = {
          mapping = {
            __raw = "cmp.mapping.preset.cmdline()";
          };
          sources = [
            {
              name = "path";
            }
            {
              name = "cmdline";
              option = {
                ignore_cmds = [
                  "Man"
                  "!"
                ];
              };
            }
          ];
          window.completion.__raw = "__cmp_cmdline_border";
        };
      };
    };
  };
}
