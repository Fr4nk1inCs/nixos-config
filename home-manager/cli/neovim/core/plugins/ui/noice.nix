{...}: let
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
      desc = item.desc;
      silent = true;
    };
  });
in {
  programs.nixvim.plugins.noice = {
    enable = true;

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

    views = views;

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

  programs.nixvim.plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>sn";
      group = "Messages (noice)";
    }
  ];
}
