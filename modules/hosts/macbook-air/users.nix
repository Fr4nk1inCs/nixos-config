{ inputs, ... }: {
  flake.modules.darwin.fr4nk1in-macbook-air = {
    imports = with inputs.self.modules.darwin; [ fr4nk1in ];

    home-manager.users.fr4nk1in.programs.nehir.settings.mouseWarp.monitorOrder = [
      "VG2481-4K"
      "LV273HUPR"
    ];
  };
}
