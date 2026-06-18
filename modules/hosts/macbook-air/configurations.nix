{ inputs, ... }: {
  flake.modules.darwin.fr4nk1in-macbook-air = {
    imports = with inputs.self.modules.darwin; [
      system-desktop
      nvidia
    ];

    networking.computerName = "Fr4nk1in's MacBook Air";
    networking.hostName = "fr4nk1in-macbook-air";
  };
}
