{ inputs, ... }: {
  flake.nixosConfigurations = inputs.self.lib.mkNixOs "x86_64-linux" "wsl";
}
