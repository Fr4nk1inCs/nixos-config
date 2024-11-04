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
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-std.url = "github:chessai/nix-std";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    nix-darwin,
    nix-ld,
    home-manager,
    nixvim,
    nix-std,
    ...
  } @ inputs: let
    user = "fr4nk1in";
    std = nix-std.lib;
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          cudaSupport = system == "x86_64-linux";
        };
        overlays = [(import ./modules/packages)];
      };
    mkHomeManagerConfig = profile: {
      home-manager = {
        extraSpecialArgs = {
          inherit std;
          flakeRoot = self;
        };
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [nixvim.homeManagerModules.nixvim];
        users.${user} = import profile;
      };
    };
    mkHomeConfig = profile:
      home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs "x86_64-linux";
        extraSpecialArgs = {
          inherit std;
          flakeRoot = self;
        };
        modules = [
          nixvim.homeManagerModules.nixvim
          profile
        ];
      };
  in {
    darwinConfigurations."fr4nk1in-macbook-air" = nix-darwin.lib.darwinSystem rec {
      system = "aarch64-darwin";
      pkgs = mkPkgs system;
      specialArgs = {
        pkgs-stable = import inputs.nixpkgs-stable {
          inherit system;
          config = {allowUnfree = true;};
        };
      };
      modules = [
        ./hosts/darwin

        home-manager.darwinModules.home-manager
        (mkHomeManagerConfig ./home-manager/profiles/darwin.nix)
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
          nix-ld.nixosModules.nix-ld
          home-manager.nixosModules.home-manager
          (mkHomeManagerConfig ./home-manager/profiles/wsl.nix)
        ];
      };

      nixos-vm = nixpkgs.lib.nixosSystem {
        pkgs = mkPkgs "x86_64-linux";
        modules = [
          ./hosts/nixos-vm

          nix-ld.nixosModules.nix-ld
          home-manager.nixosModules.home-manager
          (mkHomeManagerConfig ./home-manager)
        ];
      };
    };
  };
}
