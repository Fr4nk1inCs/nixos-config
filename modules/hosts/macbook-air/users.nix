{ inputs, ... }: {
  flake.modules.darwin.fr4nk1in-macbook-air = {
    imports = with inputs.self.modules.darwin; [ fr4nk1in ];
  };
}
