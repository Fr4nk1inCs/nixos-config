{...}: let
  expand = func: {
    __raw = ''
      function()
        return require("which-key.extras").expand.${func}()
      end
    '';
  };
in {
  programs.nixvim.plugins.which-key = {
    enable = true;
    settings = {
      win.border = "rounded";

      spec = [
        {
          __unkeyed-1 = "[";
          group = "Previous";
        }
        {
          __unkeyed-1 = "]";
          group = "Next";
        }
        {
          __unkeyed-1 = "z";
          group = "Fold";
        }
        {
          __unkeyed-1 = "<leader><tab>";
          group = "Tabs";
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "Code";
        }
        {
          __unkeyed-1 = "<leader>u";
          group = "UI / Toggle";
          icon = {
            icon = "󰙵 ";
            color = "cyan";
          };
        }
        {
          __unkeyed-1 = "<leader>b";
          group = "Buffer";
          expand = expand "buf";
        }
        {
          __unkeyed-1 = "<leader>w";
          group = "Windows";
          proxy = "<c-w>";
          expand = expand "win";
        }
        {
          __unkeyed-1 = "gx";
          group = "Open with system app";
        }
      ];
    };
  };

  programs.nixvim.keymaps = [
    {
      key = "<leader>?";
      mode = "n";
      action.__raw = ''
        function()
          require('which-key').show({ global = false })
        end
      '';
      options = {
        desc = "Buffer keymaps (which-key)";
        silent = true;
      };
    }
    {
      key = "<c-w><space>";
      mode = "n";
      action.__raw = ''
        function()
          require('which-key').show({ keys = "<c-w>", loop = true })
        end
      '';
      options = {
        desc = "Window hydra mode (which-key)";
        silent = true;
      };
    }
  ];
}
