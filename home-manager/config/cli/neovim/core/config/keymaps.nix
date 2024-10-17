{lib, ...}: let
  betterUpDown =
    builtins.map
    (item: {
      action = "v:count == 0 ? 'g${item.key}' : '${item.key}'";
      inherit (item) key;
      mode = ["n" "x"];
      options = {
        inherit (item) desc;
        expr = true;
        silent = true;
      };
    })
    [
      {
        desc = "Up";
        key = "k";
      }
      {
        desc = "Down";
        key = "j";
      }
    ];
  moveToWindow =
    builtins.map
    (item: {
      action = "<c-w>${item.key}";
      key = "<c-${item.key}>";
      mode = ["n"];
      options = {
        desc = "Go to ${item.direction} window";
        silent = true;
        remap = true;
      };
    })
    [
      {
        direction = "left";
        key = "h";
      }
      {
        direction = "lower";
        key = "j";
      }
      {
        direction = "upper";
        key = "k";
      }
      {
        direction = "right";
        key = "l";
      }
    ];
  resizeWindow =
    builtins.map
    (item: {
      action = "<cmd>${item.cmd}<cr>";
      key = "<c-${item.key}>";
      mode = ["n"];
      options = {
        inherit (item) desc;
        silent = true;
      };
    })
    [
      {
        key = "up";
        cmd = "resize +2";
        desc = "Increase window height";
      }
      {
        key = "down";
        cmd = "resize -2";
        desc = "Decrease window height";
      }
      {
        key = "left";
        cmd = "vertical resize -2";
        desc = "Decrease window width";
      }
      {
        key = "right";
        cmd = "vertical resize +2";
        desc = "Increase window width";
      }
    ];
  moveLines =
    builtins.map
    (item: {
      action = item.cmd;
      inherit (item) key;
      inherit (item) mode;
      options = {
        inherit (item) desc;
        silent = true;
      };
    })
    (
      lib.lists.flatten
      (
        builtins.map
        (item: [
          {
            key = "<a-${item.key}>";
            mode = "n";
            cmd = "<cmd>m .${item.cmd}<cr>==";
            inherit (item) desc;
          }
          {
            key = "<a-${item.key}>";
            mode = "i";
            cmd = "<esc><cmd>m .${item.cmd}<cr>==gi";
            inherit (item) desc;
          }
          {
            key = "<a-${item.key}>";
            mode = "x";
            cmd = ":m '${item.vcmd}<cr>gv=gv";
            inherit (item) desc;
          }
        ])
        [
          {
            key = "j";
            cmd = "+1";
            vcmd = ">+1";
            desc = "Move down";
          }
          {
            key = "k";
            cmd = "-2";
            vcmd = "<-2";
            desc = "Move up";
          }
        ]
      )
    );
  buffers =
    (
      builtins.map
      (key: {
        inherit key;
        action = "<cmd>e #<cr>";
        mode = "n";
        options = {
          desc = "Switch to other buffer";
          silent = true;
        };
      })
      ["<leader>bb" "<leader>`"]
    )
    ++ [
      {
        mode = "n";
        key = "<leader>bd";
        action.__raw = "utils.ui.bufremove";
        options = {
          desc = "Delete buffer";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>bD";
        action = "<cmd>bd<cr>";
        options = {
          desc = "Delete buffer and window";
          silent = true;
        };
      }
    ];
  betterIndent =
    builtins.map
    (key: {
      action = "${key}gv";
      inherit key;
      mode = "v";
    })
    ["<" ">"];
  diagnostics =
    lib.lists.flatten
    (
      builtins.map
      (item: [
        {
          key = "]${item.key}";
          mode = "n";
          action.__raw = ''
            function()
              vim.diagnostic.goto_next({ severity = ${item.severity} })
            end
          '';
          options = {
            desc = "Next ${item.desc}";
            silent = true;
          };
        }
        {
          key = "[${item.key}";
          mode = "n";
          action.__raw = ''
            function()
              vim.diagnostic.goto_prev({ severity = ${item.severity} })
            end
          '';
          options = {
            desc = "Previous ${item.desc}";
            silent = true;
          };
        }
      ])
      [
        {
          key = "d";
          severity = "nil";
          desc = "diagnostics";
        }
        {
          key = "e";
          severity = "'ERROR'";
          desc = "error";
        }
        {
          key = "w";
          severity = "'WARN'";
          desc = "warning";
        }
      ]
    )
    ++ [
      {
        key = "<leader>cd";
        action.__raw = "vim.diagnostic.open_float";
        mode = "n";
        options = {
          desc = "Line diagnostics";
          silent = true;
        };
      }
    ];
  terminalMode =
    [
      {
        key = "<esc><esc>";
        action = "<c-\\><c-n>";
        mode = "t";
        options = {
          desc = "Enter normal mode";
          silent = true;
        };
      }
    ]
    ++ builtins.map (item: {
      key = "<c-${item.key}>";
      action = "<cmd>${item.action}<cr>";
      mode = "t";
      options = {
        inherit (item) desc;
        silent = true;
      };
    }) [
      # {
      #   key = "h";
      #   action = "wincmd h";
      #   desc = "Go to left window";
      # }
      # {
      #   key = "j";
      #   action = "wincmd j";
      #   desc = "Go to lower window";
      # }
      # {
      #   key = "k";
      #   action = "wincmd k";
      #   desc = "Go to upper window";
      # }
      # {
      #   key = "l";
      #   action = "wincmd l";
      #   desc = "Go to right window";
      # }
      {
        key = "/";
        action = "close";
        desc = "Hide terminal";
      }
      {
        key = "_";
        action = "close";
        desc = "which_key_ignore";
      }
    ];
  windows =
    builtins.map
    (item: {
      key = "<leader>${item.key}";
      action = "<c-w>${item.action}";
      mode = "n";
      options = {
        inherit (item) desc;
        silent = true;
        remap = true;
      };
    })
    [
      {
        key = "w";
        action = "";
        desc = "Windows";
      }
      {
        key = "-";
        action = "s";
        desc = "Split window below";
      }
      {
        key = "|";
        action = "v";
        desc = "Split window right";
      }
      {
        key = "wd";
        action = "c";
        desc = "Delete window";
      }
    ];
  tabs =
    builtins.map
    (item: {
      key = "<leader><tab>${item.key}";
      action = "<cmd>${item.action}<cr>";
      mode = "n";
      options = {
        inherit (item) desc;
        silent = true;
      };
    })
    [
      {
        key = "l";
        action = "tablast";
        desc = "Last tab";
      }
      {
        key = "o";
        action = "tabonly";
        desc = "Close other tabs";
      }
      {
        key = "f";
        action = "tabfirst";
        desc = "First tab";
      }
      {
        key = "<tab>";
        action = "tabnew";
        desc = "New tab";
      }
      {
        key = "]";
        action = "tabnext";
        desc = "Next tab";
      }
      {
        key = "c";
        action = "tabclose";
        desc = "Close tab";
      }
      {
        key = "[";
        action = "tabprevious";
        desc = "Previous tab";
      }
    ];
  disableArrowKeys =
    builtins.map
    (key: {
      action.__raw = ''
        function()
          return utils.notify(
            "Arrow keys are disabled, use hjkl instead",
            vim.log.levels.WARN,
            { title = "Disabled" }
          );
        end'';
      inherit key;
      mode = ["n" "i" "v"];
      options = {
        silent = true;
        desc = "Disabled, use hjkl instead";
      };
    })
    ["<up>" "<down>" "<left>" "<right>"];
in {
  programs.nixvim.keymaps =
    lib.lists.flatten [
      betterUpDown
      moveToWindow
      resizeWindow
      moveLines
      buffers
      betterIndent
      diagnostics
      terminalMode
      windows
      tabs
      disableArrowKeys
    ]
    ++ [
      {
        # Clear search with <esc>
        action = "<cmd>nohlsearch<cr><esc>";
        key = "<esc>";
        mode = ["i" "n"];
        options = {
          desc = "Escape and clear search";
          silent = true;
        };
      }
      {
        # Clear search, diff update and redraw
        action = "<cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>";
        key = "<leader>ur";
        mode = ["n"];
        options = {
          desc = "Redraw / Clear search / Diff update";
          silent = true;
        };
      }
      # Previous search result
      {
        action = "'Nn'[v:searchforward].'zv'";
        key = "n";
        mode = "n";
        options = {
          desc = "Next search result";
          expr = true;
          silent = true;
        };
      }
      {
        action = "'Nn'[v:searchforward]";
        key = "n";
        mode = ["x" "o"];
        options = {
          desc = "Next search result";
          expr = true;
          silent = true;
        };
      }
      # Next search result
      {
        action = "'nN'[v:searchforward].'zv'";
        key = "N";
        mode = "n";
        options = {
          desc = "Previous search result";
          expr = true;
          silent = true;
        };
      }
      {
        action = "'nN'[v:searchforward]";
        key = "N";
        mode = ["x" "o"];
        options = {
          desc = "Previous search result";
          expr = true;
          silent = true;
        };
      }
    ];
}
