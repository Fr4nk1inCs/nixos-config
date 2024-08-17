{...}: let
  onMove = ''
    function(state)
      local changes = {
        files = {
          {
            oldUri = vim.uri_from_fname(state.source),
            newUri = vim.uri_from_fname(state.destination),
          },
        },
      }

      local clients = vim.lsp.get_clients()

      for _, client in ipairs(clients) do
        if client.support_method("workspace/willRenameFiles") then
          local response = client.request_sync("workspace/willRenameFiles", changes, 1000, 0)
          if response and response.result ~= nil then
            vim.lsp.util.apply_workspace_edit(response.result, client.offset_encoding)
          end
        end
      end

      for _, client in ipairs(clients) do
        if client.support_method("workspace/didRenameFiles") then
          client.notify("workspace/didRenameFiles", changes)
        end
      end
    end
  '';
in {
  programs.nixvim.keymaps = [
    {
      key = "<leader>fe";
      action.__raw = ''
        function()
          require("neo-tree.command").execute({ toggle = true, dir = utils.root() })
        end
      '';
      options = {
        desc = "File explorer (root)";
        silent = true;
      };
    }
    {
      key = "<leader>fE";
      action.__raw = ''
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end
      '';
      options = {
        desc = "File explorer (cwd)";
        silent = true;
      };
    }
    {
      key = "<leader>e";
      action = "<leader>fe";
      options = {
        desc = "File explorer (root)";
        remap = true;
        silent = true;
      };
    }
    {
      key = "<leader>E";
      action = "<leader>fE";
      options = {
        desc = "File explorer (cwd)";
        remap = true;
        silent = true;
      };
    }
    {
      key = "<leader>ge";
      action.__raw = ''
        function()
          require("neo-tree.command").execute({ toggle = true, source = "git_status" })
        end
      '';
      options = {
        desc = "Git explorer";
        silent = true;
      };
    }
    {
      key = "<leader>be";
      action.__raw = ''
        function()
          require("neo-tree.command").execute({ toggle = true, source = "buffers" })
        end
      '';
      options = {
        desc = "Buffer explorer";
        silent = true;
      };
    }
    {
      key = "<leader>se";
      action.__raw = ''
        function()
          require("neo-tree.command").execute({ toggle = true, source = "document_symbols" })
        end
      '';
      options = {
        desc = "Symbol explorer";
        silent = true;
      };
    }
  ];

  programs.nixvim.plugins.neo-tree = {
    enable = true;

    popupBorderStyle = "rounded";

    defaultComponentConfigs = {
      indent = {
        withExpanders = true;
        expanderCollapsed = "";
        expanderExpanded = "";
        expanderHighlight = "NeoTreeExpander";
      };
      gitStatus = {
        symbols = {
          unstaged = "󰄱";
          staged = "󰱒";
        };
      };
      icon = {
        folderClosed = "";
        folderOpen = "";
        folderEmpty = "";
      };
    };

    filesystem = {
      filteredItems.hideDotfiles = false;
      groupEmptyDirs = false;
      followCurrentFile.enabled = true;
    };

    defaultSource = "filesystem";
    sources = [
      "filesystem"
      "buffers"
      "git_status"
      "document_symbols"
    ];
    sourceSelector = {
      winbar = true;
      padding = 1;
      highlightTab = "BufferLineBuffer";
      highlightTabActive = "BufferLineBufferSelected";
      highlightBackground = "BufferLineBuffer";
      highlightSeparator = "BufferLineSeparator";
      highlightSeparatorActive = "BufferLineSeparatorSelected";
      sources = [
        {
          source = "filesystem";
          displayName = " Files";
        }
        {
          source = "buffers";
          displayName = " Buffers";
        }
        {
          source = "git_status";
          displayName = " Git";
        }
        {
          source = "document_symbols";
          displayName = " Symbols";
        }
      ];
    };
    eventHandlers = {
      file_moved = onMove;
      file_renamed = onMove;
    };
  };

  programs.nixvim.autoCmd = [
    {
      event = "TermClose";
      pattern = "*lazygit";
      callback.__raw = ''
        function()
          require("neo-tree.sources.git_status").refresh()
        end
      '';
    }
  ];
}
