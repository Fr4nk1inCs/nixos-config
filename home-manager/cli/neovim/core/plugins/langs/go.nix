{pkgs, ...}: {
  programs.nixvim.plugins = {
    treesitter.settings.ensure_installed = ["go" "gomod" "gowork" "gosum"];
    lsp.servers.gopls = {
      enable = true;
      settings.gopls = {
        gofumpt = true;
        codelenses = {
          gc_details = false;
          generate = true;
          regenerate_cgo = true;
          run_govulncheck = true;
          test = true;
          tidy = true;
          upgrade_dependency = true;
          vendor = true;
        };
        hints = {
          assignVariableTypes = true;
          compositeLiteralFields = true;
          compositeLiteralTypes = true;
          constantValues = true;
          functionTypeParameters = true;
          parameterNames = true;
          rangeVariableTypes = true;
        };
        analyses = {
          fieldalignment = true;
          nilness = true;
          unusedparams = true;
          unusedwrite = true;
          useany = true;
        };
        usePlaceholders = true;
        completeUnimported = true;
        staticcheck = true;
        directoryFilters = ["-.git" "-.vscode" "-.idea" "-.vscode-test" "-node_modules"];
        semanticTokens = true;
      };
      onAttach.function = ''
        if not client.server_capabilities.semanticTokensProvider then
        local semantic = client.config.capabilities.textDocument.semanticTokens;
          client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = {
              tokenTypes = semantic.tokenTypes,
              tokenModifiers = semantic.tokenModifiers,
            },
            range = true,
          }
        end
      '';
    };
    dap.extensions.dap-go.enable = true;
    none-ls.sources = {
      code_actions.gomodifytags.enable = true;
      code_actions.impl.enable = true;
      formatting.gofumpt.enable = true;
      formatting.goimports.enable = true;
    };
  };

  programs.nixvim.extraPackages = with pkgs; [gotools gofumpt delve];
}
