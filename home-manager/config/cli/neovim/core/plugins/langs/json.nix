_: {
  programs.nixvim.plugins = {
    treesitter.settings.ensure_installed = ["json5"];
    lsp.servers.jsonls = {
      enable = true;
      settings.json = {
        format.enable = true;
        validate.enable = true;
      };
      extraOptions.on_new_config.__raw = ''
        function(new_config)
          new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
        end
      '';
    };
    schemastore.enable = true;
  };
}
