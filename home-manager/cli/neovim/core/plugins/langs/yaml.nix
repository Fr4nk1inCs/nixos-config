{...}: {
  programs.nixvim.plugins = {
    treesitter.settings.ensure_installed = ["json5"];
    lsp.servers.yamlls = {
      enable = true;

      settings = {
        redhat.telemetry.enabled = true;
        yaml = {
          keyOrdering = true;
          format.enable = true;
          validate = true;
          schemaStore = {
            enable = false;
            url = "";
          };
        };
      };

      extraOptions = {
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false;
          lineFoldingOnly = true;
        };

        on_new_config.__raw = ''
          function(new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end
        '';
      };

      onAttach.function = "client.server_capabilities.documentFormattingProvider = true";
    };
    schemastore.enable = true;
  };
}
