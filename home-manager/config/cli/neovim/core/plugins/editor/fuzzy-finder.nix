{pkgs, ...}: let
  actions = func: {__raw = ''require("fzf-lua.actions").${func}'';};
  UISelect = ''
    function(fzf_opts, items)
      return vim.tbl_deep_extend("force", fzf_opts, {
        prompt = " ",
        winopts = {
          title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
          title_pos = "center",
        },
      }, fzf_opts.kind == "codeaction" and {
        winopts = {
          layout = "vertical",
          -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
          height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
          width = 0.5,
          preview = not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
            layout = "vertical",
            vertical = "down:15,border-top",
            hidden = "hidden",
          } or {
            layout = "vertical",
            vertical = "down:15,border-top",
          },
        },
      } or {
        winopts = {
          width = 0.5,
          -- height is number of items, with a max of 80% screen height
          height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
        },
      })
    end
  '';
  toggleRootDir.__raw = ''
    function(_, ctx)
      local o = vim.deepcopy(ctx.__call_opts)
      o.root = o.root == false
      o.buf = ctx.__CTX.bufnr

      o.cwd = o.root and utils.root({ buf = o.buf }) or nil
      require("fzf-lua")[ctx.__INFO.cmd](o)
    end
  '';
  openInRoot = cmd: {
    __raw = ''
      function()
        local buf = vim.api.nvim_get_current_buf()
        local cwd = utils.root({ buf = buf })
        require("fzf-lua").${cmd}({ cwd = cwd, root = true })
      end
    '';
  };
  openInCwd = cmd: {
    __raw = ''
      function()
        require("fzf-lua").${cmd}({ cwd = cwd, root = false })
      end
    '';
  };
  lspOperation = cmd: "<cmd>FzfLua lsp_${cmd} jump_to_single_result=true ignore_current_line=true<cr>";
  map = keymap: {
    inherit (keymap) key;
    mode = keymap.mode or "n";
    inherit (keymap) action;
    options = {
      inherit (keymap) desc;
      silent = true;
    };
  };
in {
  programs.nixvim = {
    plugins = {
      fzf-lua = {
        enable = true;

        profile.__raw = ''"default-title"'';

        settings = {
          fzf_color = true;
          winopts = {
            width = 0.8;
            height = 0.8;
            row = 0.5;
            col = 0.5;
            preview = {
              scrollchars = ["┃" ""];
            };
          };
          files = {
            actions = {
              "alt-i" = [(actions "toggle_ignore")];
              "alt-h" = [(actions "toggle_hidden")];
            };
          };
          grep = {
            actions = {
              "alt-i" = [(actions "toggle_ignore")];
              "alt-h" = [(actions "toggle_hidden")];
            };
          };
          lsp = {
            symbol_fmt.__raw = ''function(s) return s:lower() .. ":" end'';
            code_actions.previewer = "codeaction_native";
          };
          actions.files = {
            __unkeyed-1 = true;
            "ctrl-t".__raw = ''require("trouble.sources.fzf").actions.open'';
            "ctrl-r" = toggleRootDir;
            "alt-c" = toggleRootDir;
          };
          keymap = {
            fzf = {
              "ctrl-q" = "select-all+select";
              "ctrl-u" = "half-page-up";
              "ctrl-d" = "half-page-down";
              "ctrl-x" = "jump";
              "ctrl-f" = "preview-page-down";
              "ctrl-b" = "preview-page-up";
            };

            builtin = {
              "<c-f>" = "preview-page-down";
              "<c-b>" = "preview-page-up";
            };
          };
          previewers.builtin = {
            extensions = {
              png = ["${pkgs.chafa}/bin/chafa" "--format=symbols"];
              svg = ["${pkgs.chafa}/bin/chafa" "--format=symbols"];
              jpg = ["${pkgs.chafa}/bin/chafa" "--format=symbols"];
              gif = ["${pkgs.chafa}/bin/chafa" "--format=symbols"];
            };
          };
        };

        keymaps = {
          "<leader>," = {
            action = "buffers";
            options = {
              desc = "Switch buffer";
              silent = true;
            };
            settings = {
              sort_mru = true;
              sort_lastused = true;
            };
          };
          "<leader>:" = {
            action = "command_history";
            options = {
              desc = "Command history";
              silent = true;
            };
          };
          "<leader>fb" = {
            action = "buffers";
            options = {
              desc = "Switch buffer";
              silent = true;
            };
            settings = {
              sort_mru = true;
              sort_lastused = true;
            };
          };
          "<leader>fg" = {
            action = "git_files";
            options = {
              desc = "Find files (git-files)";
              silent = true;
            };
          };
          "<leader>fr" = {
            action = "oldfiles";
            options = {
              desc = "Recent files";
              silent = true;
            };
          };
          "<leader>gc" = {
            action = "git_commits";
            options = {
              desc = "Git commits";
              silent = true;
            };
          };
          "<leader>gs" = {
            action = "git_status";
            options = {
              desc = "Git status";
              silent = true;
            };
          };
          "<leader>s\"" = {
            action = "registers";
            options = {
              desc = "Registers";
              silent = true;
            };
          };
          "<leader>sa" = {
            action = "autocmds";
            options = {
              desc = "Autocommands";
              silent = true;
            };
          };
          "<leader>sb" = {
            action = "grep_curbuf";
            options = {
              desc = "Grep buffer";
              silent = true;
            };
          };
          "<leader>sc" = {
            action = "command_history";
            options = {
              desc = "Command history";
              silent = true;
            };
          };
          "<leader>sC" = {
            action = "commands";
            options = {
              desc = "Commands";
              silent = true;
            };
          };
          "<leader>sd" = {
            action = "diagnostics_document";
            options = {
              desc = "Document diagnostics";
              silent = true;
            };
          };
          "<leader>sD" = {
            action = "diagnostics_workspace";
            options = {
              desc = "Workspace diagnostics";
              silent = true;
            };
          };
          "<leader>sh" = {
            action = "help_tags";
            options = {
              desc = "Help pages";
              silent = true;
            };
          };
          "<leader>sH" = {
            action = "highlights";
            options = {
              desc = "Search highlights";
              silent = true;
            };
          };
          "<leader>sj" = {
            action = "jumps";
            options = {
              desc = "Jumplist";
              silent = true;
            };
          };
          "<leader>sk" = {
            action = "keymaps";
            options = {
              desc = "Keymaps";
              silent = true;
            };
          };
          "<leader>sl" = {
            action = "loclist";
            options = {
              desc = "Loclist";
              silent = true;
            };
          };
          "<leader>sm" = {
            action = "marks";
            options = {
              desc = "Jump to marks";
              silent = true;
            };
          };
          "<leader>sM" = {
            action = "man_pages";
            options = {
              desc = "Man pages";
              silent = true;
            };
          };
          "<leader>sR" = {
            action = "resume";
            options = {
              desc = "Resume FZF";
              silent = true;
            };
          };
          "<leader>sq" = {
            action = "quickfix";
            options = {
              desc = "Quickfix list";
              silent = true;
            };
          };
          "<leader>ss" = {
            action = "lsp_document_symbols";
            options = {
              desc = "Document symbols";
              silent = true;
            };
          };
          "<leader>sS" = {
            action = "lsp_workspace_symbols";
            options = {
              desc = "Workspace symbols";
              silent = true;
            };
          };
          "<leader>uC" = {
            action = "colorschemes";
            options = {
              desc = "Colorschemes";
              silent = true;
            };
          };
        };
      };

      lsp.keymaps.extra = [
        (map {
          key = "gd";
          action = lspOperation "definitions";
          desc = "Goto definition";
        })
        (map {
          key = "gr";
          action = lspOperation "references";
          desc = "References";
        })
        (map {
          key = "gI";
          action = lspOperation "implementations";
          desc = "Goto implementation";
        })
        (map {
          key = "gy";
          action = lspOperation "typedefs";
          desc = "Goto t[y]pe definition";
        })
      ];

      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>f";
          group = "File / Find";
        }
        {
          __unkeyed-1 = "<leader>s";
          group = "Search";
        }
      ];
    };

    keymaps = [
      (map {
        key = "<leader>/";
        action = openInRoot "live_grep";
        desc = "Live grep (root)";
      })
      (map {
        key = "<leader><space>";
        action = openInRoot "files";
        desc = "Find files (root)";
      })
      (map {
        key = "<leader>ff";
        action = openInRoot "files";
        desc = "Find files (root)";
      })
      (map {
        key = "<leader>fF";
        action = openInCwd "files";
        desc = "Find files (cwd)";
      })
      (map {
        key = "<leader>fR";
        action.__raw = ''function() require("fzf-lua").oldfiles({ cwd = vim.uv.cwd() }) end'';
        desc = "Recent files (cwd)";
      })
      (map {
        key = "<leader>sg";
        action = openInRoot "live_grep";
        desc = "Live grep (root)";
      })
      (map {
        key = "<leader>sG";
        action = openInCwd "live_grep";
        desc = "Live grep (cwd)";
      })
      (map {
        key = "<leader>sw";
        action = openInRoot "grep_cword";
        desc = "Grep word (root)";
      })
      (map {
        key = "<leader>sW";
        action = openInCwd "grep_cword";
        desc = "Grep word (cwd)";
      })
      (map {
        key = "<leader>sw";
        mode = "v";
        action = openInRoot "grep_visual";
        desc = "Grep selection (root)";
      })
      (map {
        key = "<leader>sW";
        mode = "v";
        action = openInCwd "grep_visual";
        desc = "Grep selection (cwd)";
      })
    ];

    extraConfigLuaPost = ''
      do
        require("fzf-lua").register_ui_select(${UISelect})
      end
    '';
  };
}
