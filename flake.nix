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
  };

  outputs = {
    nixpkgs,
    nixos-wsl,
    nix-darwin,
    home-manager,
    nixvim,
    ...
  } @ inputs: let
    user = "fushen";
    x86DarwinPkgs = import nixpkgs {
      system = "x86_64-darwin";
      config.allowUnfree = true;
    };
    appleSiliconDarwinPkgs = import nixpkgs {
      system = "aarch64-darwin";
      config.allowUnfree = true;
    };
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        cudaSupport = true;
      };
    };
  in {
    darwinConfigurations."fushen-mac" = nix-darwin.lib.darwinSystem {
      pkgs = x86DarwinPkgs;
      system = "x86_64-darwin";
      modules = [
        ./hosts/darwin

        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            sharedModules = [nixvim.homeManagerModules.nixvim];

            users.${user} = import ./hosts/home-manager/darwin.nix;
            extraSpecialArgs = inputs;
          };
        }
      ];
    };

    homeConfigurations = {
      # lab server
      sf = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nixvim.homeManagerModules.nixvim
          ./hosts/home-manager/sf.nix
        ];
      };
      fushen = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nixvim.homeManagerModules.nixvim
          ./hosts/home-manager/fushen.nix
        ];
      };
      test = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nixvim.homeManagerModules.nixvim
          ./hosts/home-manager/test.nix
        ];
      };
    };
    nixosConfigurations = {
      wsl = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        modules = [
          ./hosts/wsl

          nixos-wsl.nixosModules.wsl

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              sharedModules = [nixvim.homeManagerModules.nixvim];

              users.${user} = import ./hosts/home-manager/wsl.nix;
              extraSpecialArgs = inputs;
            };
          }
        ];
      };

      nixos-vm = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        modules = [
          ./hosts/nixos-vm

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              sharedModules = [nixvim.homeManagerModules.nixvim];

              users.${user} = import ./home-manager;
              extraSpecialArgs = inputs;
            };
          }
        ];
      };
    };
  };
}
