{pkgs, ...}: let
  views = builtins.listToAttrs (
    builtins.map (
      item: {
        name = item;
        value = {
          win_options.winblend = 0;
        };
      }
    )
    ["popup" "notify" "cmdline_popup" "popupmenu" "mini"]
  );
  noiceNotifyKeymap = builtins.map (item: {
    key = "<leader>sn${item.key}";
    action.__raw = ''function() require("noice").cmd("${item.arg}") end'';
    options = {
      inherit (item) desc;
      silent = true;
    };
  });
in {
  programs.nixvim.plugins = {
    noice = {
      enable = true;
      # FIX: Wait for issue https://github.com/folke/noice.nvim/issues/921 to be fixed
      package = pkgs.vimUtils.buildVimPlugin {
        name = "noice-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "iguanacucumber";
          repo = "noice.nvim";
          rev = "c609f1145a0d06f30b629326030e7555b11ccda3";
          hash = "sha256-XQzHCvStT3jHDhxsWWkJaL5VMO+g+/6FUYe5L6P4BG4=";
        };
      };

      lsp = {
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
        signature.opts = {
          relative = "cursor";
          size.width = 60;
        };
      };

      inherit views;

      routes = [
        {
          filter = {
            event = "msg_show";
            any = [
              {find = "%d+L; %d+B";}
              {find = "; after #%d+";}
              {find = "; before #%d+";}
            ];
          };
          view = "mini";
        }
      ];

      presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
        lsp_doc_border = true;
        inc_rename = true;
      };

      markdown.hover = {
        "|(%S-)|".__raw = "vim.cmd.help"; # vim help links
        "%[.-%]%((%S-)%)".__raw = ''require("noice.util").open''; # markdown links
      };
    };

    which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>sn";
        group = "Messages (noice)";
      }
    ];
  };

  programs.nixvim.keymaps =
    [
      {
        key = "<s-enter>";
        action.__raw = ''
          function()
            require("noice").redirect(vim.fn.getcmdline())
          end
        '';
        mode = "c";
        options = {
          desc = "Redirect cmdline";
          silent = true;
        };
      }
      {
        key = "<c-f>";
        mode = ["i" "n" "s"];
        action.__raw = ''
          function()
            if not require("noice.lsp").scroll(4) then
              return "<c-f>"
            end
          end
        '';
        options = {
          expr = true;
          silent = true;
          desc = "Scroll forward";
        };
      }
      {
        key = "<c-b>";
        mode = ["i" "n" "s"];
        action.__raw = ''
          function()
            if not require("noice.lsp").scroll(-4) then
              return "<c-b>"
            end
          end
        '';
        options = {
          expr = true;
          silent = true;
          desc = "Scroll backward";
        };
      }
    ]
    ++ noiceNotifyKeymap [
      {
        key = "l";
        arg = "last";
        desc = "Last (noice) message";
      }
      {
        key = "h";
        arg = "history";
        desc = "History (noice) messages";
      }
      {
        key = "a";
        arg = "all";
        desc = "All (noice) messages";
      }
      {
        key = "d";
        arg = "dismiss";
        desc = "Dismiss (noice) messages";
      }
      {
        key = "t";
        arg = "pick";
        desc = "Pick (noice) messages (FzfLua)";
      }
    ];
}
