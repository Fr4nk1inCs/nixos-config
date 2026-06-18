{ inputs, ... }: {
  flake.modules.nixos.wsl = {
    imports = with inputs.self.modules.nixos; [ fr4nk1in ];

    wsl.defaultUser = "fr4nk1in";
  };
}
