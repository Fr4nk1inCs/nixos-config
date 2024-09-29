{
  config,
  pkgs,
  lib,
  ...
}: let
  # enable = config.homeManagerConfig.nixvimConfig.type == "full";
  enable = false;
  inherit (config.homeManagerConfig) system;
  workspaces = [
    {
      name = "Master Knowledge Base";
      path =
        {
          wsl = "/mnt/c/Users/fushen/OneDrive/master-kb";
          linux = "~/OneDrive/master-kb";
          darwin = "~/Library/CloudStorage/OneDrive/master-kb";
        }
        .${system};
    }
  ];
  openUrlCmd =
    {
      wsl = "wsl-open";
      linux = "xdg-open";
      darwin = "open";
    }
    .${system};
  openPackages =
    {
      wsl = [pkgs.wsl-open];
      linux = [pkgs.xdg-utils];
      darwin = [];
    }
    .${system};
in {
  config = lib.mkIf enable {
    programs.nixvim = {
      plugins.obsidian = {
        enable = true;

        settings = {
          inherit workspaces;

          picker.name = "fzf-lua";

          ui.enable = false;

          new_notes_location = "current_dir";

          follow_url_func.__raw = ''
            function(url)
              vim.fn.jobstart({ "${openUrlCmd}", url }, { detach = true })
            end
          '';
          note_id_func.__raw = ''
            function(title)
              return title
            end
          '';

          attachments.img_folder = "999 - Meta/Assets";
          image_name_func.__raw = ''
            function()
              return string.format("Pasted Image %s", os.date("%Y%m%d%H%M%S"))
            end
          '';
        };
      };

      userCommands = {
        Obsidian.command.__raw = ''
          function(opts)
            local client = require("obsidian")._client
            local picker = client:picker()

            local options = {}
            for i, spec in ipairs(client.opts.workspaces) do
              local workspace = require("obsidian.workspace").new_from_spec(spec)
              if workspace == client.current_workspace then
                options[#options + 1] = string.format("*[%d] %s @ '%s'", i, workspace.name, workspace.path)
              else
                options[#options + 1] = string.format("[%d] %s @ '%s'", i, workspace.name, workspace.path)
              end
            end

            picker:pick(options, {
              prompt_title = "Workspaces",
              callback = function(workspace_str)
                local idx = tonumber(string.match(workspace_str, "%*?%[(%d+)]"))
                local workspace = client.opts.workspaces[idx]
                client:switch_workspace(workspace.name, { lock = true })
                vim.fn.chdir(workspace.path)
                vim.cmd("SessionRestore")
              end,
            })
          end
        '';
      };

      extraPackages = openPackages;
    };
  };
}
