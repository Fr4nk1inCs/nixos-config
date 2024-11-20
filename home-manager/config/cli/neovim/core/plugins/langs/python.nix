{pkgs, ...}: {
  programs.nixvim.plugins = {
    treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      ninja
      rst
    ];

    lsp.servers.basedpyright = {
      enable = true;

      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "standard";
            inlayHints = {
              callArgumentNames = "partial";
              functionReturnTypes = true;
              pytestParameters = true;
              variableTypes = true;
            };
          };
        };
      };
    };

    lsp.servers.ruff = {
      extraOptions = {
        cmd_env = {RUFF_TRACE = "messages";};
        init_options = {
          settings = {
            logLevel = "error";
          };
        };
      };

      onAttach.function = "client.server_capabilities.hoverProvider = false";
    };

    dap.extensions.dap-python = {
      enable = true;
    };

    cmp.settings.auto_brackets = ["python"];

    none-ls.sources.formatting = {
      black.enable = true;
      isort.enable = true;
    };
  };
}
