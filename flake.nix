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
    home-manager,
    nixvim,
    nix-std,
    ...
  } @ inputs: let
    user = "fr4nk1in";
    std = nix-std.lib;
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        cudaSupport = true;
      };
      overlays = [(import ./modules/packages)];
    };
    appleSiliconDarwinPkgs = import nixpkgs {
      system = "aarch64-darwin";
      config.allowUnfree = true;
      overlays = [(import ./modules/packages)];
    };
    mkHomeManagerConfig = profile: {
      home-manager = {
        extraSpecialArgs = {inherit std;};
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [nixvim.homeManagerModules.nixvim];
        users.${user} = import profile;
      };
    };
    mkHomeConfig = profile:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit std;};
        modules = [
          nixvim.homeManagerModules.nixvim
          profile
        ];
      };
  in {
    darwinConfigurations."fr4nk1in-macbook-air" = nix-darwin.lib.darwinSystem {
      pkgs = appleSiliconDarwinPkgs;
      system = "aarch64-darwin";
      modules = [
        "${self}/hosts/darwin"

        home-manager.darwinModules.home-manager
        (mkHomeManagerConfig "${self}/home-manager/profiles/darwin.nix")
      ];
    };

    homeConfigurations = {
      # lab server
      cmdline = mkHomeConfig "${self}/home-manager/profiles/cmdline.nix";
      test = mkHomeConfig "${self}/home-manager/profiles/test.nix";
    };
    nixosConfigurations = {
      wsl = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        modules = [
          "${self}/hosts/wsl"

          nixos-wsl.nixosModules.wsl

          home-manager.nixosModules.home-manager
          (mkHomeManagerConfig "${self}/home-manager/profiles/wsl.nix")
        ];
      };

      nixos-vm = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        modules = [
          "${self}/hosts/nixos-vm"

          home-manager.nixosModules.home-manager
          (mkHomeManagerConfig "${self}/home-manager")
        ];
      };
    };
  };
}
