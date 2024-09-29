_: let
  dapKeymap = builtins.map (item: {
    key = "<leader>d${item.key}";
    action.__raw = ''function() require("dap").${item.func}() end'';
    options = {
      silent = true;
      inherit (item) desc;
    };
  });
in {
  programs.nixvim = {
    plugins.dap = {
      enable = true;

      extensions = {
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
      };

      signs = {
        dapBreakpoint = {
          text = " ";
          texthl = "DiagnosticInfo";
        };
        dapBreakpointCondition = {
          text = " ";
          texthl = "DiagnosticInfo";
        };
        dapBreakpointRejected = {
          text = " ";
          texthl = "DiagnosticError";
        };
        dapLogPoint = {
          text = ".>";
          texthl = "DiagnosticInfo";
        };
        dapStopped = {
          text = "󰁕 ";
          texthl = "DiagnosticWarn";
          linehl = "DapStoppedLine";
        };
      };
    };

    highlight = {
      DapStoppedLine = {
        default = true;
        link = "Visual";
      };
    };

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>d";
        group = "Debug";
      }
    ];

    keymaps =
      [
        {
          key = "<leader>dB";
          action.__raw = ''
            function()
              require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end
          '';
          options = {
            silent = true;
            desc = "Set breakpoint condition";
          };
        }
        {
          key = "<leader>da";
          action.__raw = ''
            function()
              ---@param config {args?:string[]|fun():string[]?}
              local function get_args(config)
                local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
                config = vim.deepcopy(config)
                ---@cast args string[]
                config.args = function()
                  local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
                  return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
                end
                return config
              end
              require("dap").continue({ before = get_args })
            end
          '';
          options = {
            silent = true;
            desc = "Set breakpoint condition";
          };
        }
        {
          key = "<leader>dw";
          action.__raw = ''
            function()
              require("dap.ui.widgets").hover()
            end
          '';
          options = {
            silent = true;
            desc = "Widget hover";
          };
        }
        {
          key = "<leader>du";
          action.__raw = ''
            function()
              require("dapui").toggle({  })
            end
          '';
          options = {
            silent = true;
            desc = "Toggle dap UI";
          };
        }
        {
          key = "<leader>de";
          action.__raw = ''
            function()
              require("dap.ui").eval()
            end
          '';
          mode = ["n" "v"];
          options = {
            silent = true;
            desc = "Eval expression";
          };
        }
      ]
      ++ dapKeymap [
        {
          key = "b";
          func = "toggle_breakpoint";
          desc = "Toggle breakpoint";
        }
        {
          key = "c";
          func = "continue";
          desc = "Continue";
        }
        {
          key = "C";
          func = "run_to_cursor";
          desc = "Run to cursor";
        }
        {
          key = "g";
          func = "goto_";
          desc = "Goto line (no execution)";
        }
        {
          key = "i";
          func = "step_into";
          desc = "Step into";
        }
        {
          key = "j";
          func = "down";
          desc = "Down";
        }
        {
          key = "k";
          func = "up";
          desc = "Up";
        }
        {
          key = "l";
          func = "run_last";
          desc = "Run last";
        }
        {
          key = "o";
          func = "step_out";
          desc = "Step out";
        }
        {
          key = "O";
          func = "step_over";
          desc = "Step over";
        }
        {
          key = "p";
          func = "pause";
          desc = "Pause";
        }
        {
          key = "r";
          func = "repl.toggle";
          desc = "Toggle REPL";
        }
        {
          key = "s";
          func = "session";
          desc = "Session";
        }
        {
          key = "t";
          func = "terminate";
          desc = "Terminate";
        }
      ];

    extraConfigLuaPost = ''
      do
        local dap = require("dap")
        local dapui = require("dapui")
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end
      end
    '';
  };
}
