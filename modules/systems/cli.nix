{ inputs, ... }: {
  flake.modules = {
    nixos.system-cli = {
      imports = with inputs.self.modules.nixos; [
        system-default

        ssh
        mesh
        proxy
        sudo

        cli
        shell
      ];
    };

    darwin.system-cli = {
      imports = with inputs.self.modules.darwin; [
        system-default

        ssh
        mesh
        proxy
        sudo

        cli
        shell
      ];
    };

    homeManager.system-cli = {
      imports = with inputs.self.modules.homeManager; [
        system-default

        themes

        cli
        shell
        agents
      ];
    };
  };
}
