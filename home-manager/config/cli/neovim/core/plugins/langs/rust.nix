{pkgs, ...}: {
  programs.nixvim.plugins = {
    treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [rust ron];
    crates-nvim = {
      enable = true;
      extraOptions = {
        completion.cmp.enabled = true;
      };
    };
    cmp.settings.sources = [{name = "crates";}];
    lsp.servers.taplo.enable = true;
    rustaceanvim = {
      enable = true;
      settings = {
        server = {
          capabilities = {
            # https://github.com/hrsh7th/cmp-nvim-lsp/issues/44#issuecomment-2096368152
            workspace.didChangeWatchedFiles.dynamicRegistration = true;
          };
          on_attach.__raw = ''
            function(client, bufnr)
              vim.keymap.set("n", "<leader>cR", function()
                vim.cmd.RustLsp("codeAction")
              end, { desc = "Code Action", buffer = bufnr })
              vim.keymap.set("n", "<leader>dr", function()
                vim.cmd.RustLsp("debuggables")
              end, { desc = "Rust Debuggables", buffer = bufnr })
              return _M.lspOnAttach(client, bufnr)
            end
          '';
          default_settings.rust-analyzer = {
            cargo = {
              allFeatures = true;
              loadOutDirsFromCheck = true;
              buildScripts = {
                enable = true;
              };
            };
            checkOnSave = true;
            files = {
              excludeDirs = [
                "_build"
                ".dart_tool"
                ".direnv"
                ".flatpak-builder"
                ".git"
                ".gitlab"
                ".gitlab-ci"
                ".gradle"
                ".idea"
                ".next"
                ".project"
                ".scannerwork"
                ".settings"
                ".venv"
                "archetype-resources"
                "bin"
                "hooks"
                "node_modules"
                "po"
                "screenshots"
                "target"
              ];
            };
            procMacro = {
              enable = true;
              ignored = {
                async-trait = ["async_trait"];
                napi-derive = ["napi"];
                async-recursion = ["async_recursion"];
              };
            };
          };
        };
        tools.float_win_config.border = "rounded";
      };
    };
  };

  programs.nixvim.extraPackages = with pkgs; [lldb];
}
