{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official source, using branch nixos-23.11
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }@inputs: {
    nixosConfigurations = {
      wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/wsl
          nixos-wsl.nixosModules.wsl
        ];
      };
    };
  };
}
