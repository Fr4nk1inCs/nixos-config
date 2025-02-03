{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official source, using branch nixos-23.11
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats = {
      url = "github:Fr4nk1inCs/nixcats-nvim";
    };

    nix-std.url = "github:chessai/nix-std";

    agenix.url = "github:ryantm/agenix";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    nix-darwin,
    home-manager,
    ...
  } @ inputs: let
    user = "fr4nk1in";
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          cudaSupport = system == "x86_64-linux";
        };
        overlays = [
          (import ./modules/packages)
        ];
      };
    mkHomeManagerConfig = profile: {
      home-manager = {
        extraSpecialArgs = {
          inherit inputs;
        };
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${user} = import profile;
      };
    };
    mkHomeConfig = profile:
      home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs "x86_64-linux";
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          profile
        ];
      };
  in {
    darwinConfigurations."fr4nk1in-macbook-air" = nix-darwin.lib.darwinSystem rec {
      system = "aarch64-darwin";
      pkgs = mkPkgs system;
      modules = [
        ./hosts/darwin

        home-manager.darwinModules.home-manager
        (mkHomeManagerConfig ./home-manager/profiles/darwin.nix)

        inputs.agenix.darwinModules.default
      ];
    };

    homeConfigurations = {
      # lab server
      cmdline = mkHomeConfig ./home-manager/profiles/cmdline.nix;
      test = mkHomeConfig ./home-manager/profiles/test.nix;
    };
    nixosConfigurations = {
      wsl = nixpkgs.lib.nixosSystem {
        pkgs = mkPkgs "x86_64-linux";
        modules = [
          ./hosts/wsl

          nixos-wsl.nixosModules.wsl
          home-manager.nixosModules.home-manager
          (mkHomeManagerConfig ./home-manager/profiles/wsl.nix)

          inputs.nix-ld.nixosModules.nix-ld

          inputs.agenix.nixosModules.default
        ];
      };

      nixos-vm = nixpkgs.lib.nixosSystem {
        pkgs = mkPkgs "x86_64-linux";
        modules = [
          ./hosts/nixos-vm

          home-manager.nixosModules.home-manager
          (mkHomeManagerConfig ./home-manager)

          inputs.nix-ld.nixosModules.nix-ld

          inputs.agenix.nixosModules.default
        ];
      };
    };
  };
}
