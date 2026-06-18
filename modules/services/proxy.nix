{ self, ... }: {
  flake.modules = {
    nixos.proxy = { pkgs, config, ... }: {
      age.secrets.mihomo.file = self.lib.getAgeSource "mihomo.age";

      services.mihomo = {
        enable = true;
        tunMode = true;
        webui = pkgs.metacubexd;
        configFile = config.age.secrets.mihomo.path;
      };
    };

    darwin.proxy = {
      # We may switch to mihomo services in the future
      homebrew.casks = [ "clash-verge-rev" ];
    };
  };
}
