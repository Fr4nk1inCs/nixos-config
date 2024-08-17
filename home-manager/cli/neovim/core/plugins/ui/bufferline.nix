{...}: let
  bufferLineKeymap = builtins.map (item: {
    key = item.key;
    action = "<cmd>BufferLine${item.action}<cr>";
    options = {
      desc = item.desc;
      silent = true;
    };
  });
in {
  programs.nixvim.plugins.bufferline = {
    enable = true;
    settings = {
      options = {
        close_command.__raw = "function(n) utils.ui.bufremove(n) end";
        right_mouse_command.__raw = "function(n) utils.ui.bufremove(n) end";

        diagnostics = "nvim_lsp";
        diagnostics_indicator.__raw = ''
          function(_, _, diag)
            local icons = utils.icons.diagnostics
            local error = diag.error and icons.error .. diag.error .. " " or ""
            local warning = diag.warning and icons.warn .. diag.warning .. " " or ""
            return vim.trim(error .. warning)
          end
        '';

        always_show_bufferline = false;

        offsets = [
          {
            filetype = "neo-tree";
            text = "Neo-tree";
            highlight = "Directory";
            text_align = "center";
            separator = true;
          }
        ];
      };
    };
  };

  programs.nixvim.keymaps = bufferLineKeymap [
    {
      key = "<leader>bp";
      action = "TogglePin";
      desc = "Toggle pin";
    }
    {
      key = "<leader>bP";
      action = "GroupClose ungrouped";
      desc = "Close all unpinned buffers";
    }
    {
      key = "<leader>bo";
      action = "CloseOthers";
      desc = "Close other buffers";
    }
    {
      key = "<leader>bl";
      action = "CloseLeft";
      desc = "Close buffers to the left";
    }
    {
      key = "<leader>br";
      action = "CloseRight";
      desc = "Close buffers to the right";
    }
    {
      key = "<s-h>";
      action = "CyclePrev";
      desc = "Previous buffer";
    }
    {
      key = "<s-l>";
      action = "CycleNext";
      desc = "Next buffer";
    }
    {
      key = "[b";
      action = "CyclePrev";
      desc = "Previous buffer";
    }
    {
      key = "]b";
      action = "CycleNext";
      desc = "Next buffer";
    }
    {
      key = "[B";
      action = "MovePrev";
      desc = "Move buffer to previous";
    }
    {
      key = "]B";
      action = "MoveNext";
      desc = "Move buffer to next";
    }
  ];
}
