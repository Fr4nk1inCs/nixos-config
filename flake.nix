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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-std.url = "github:chessai/nix-std";

    agenix.url = "github:ryantm/agenix";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        backupFileExtension = "hm-backup";
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
    mkDarwinConfig = config:
      nix-darwin.lib.darwinSystem rec {
        inherit (config) system;
        pkgs = mkPkgs system;
        modules =
          [
            ./hosts/darwin

            home-manager.darwinModules.home-manager
            (mkHomeManagerConfig config.home-manager)

            inputs.agenix.darwinModules.default
            inputs.stylix.darwinModules.stylix
          ]
          ++ pkgs.lib.attrByPath ["extra-modules"] [] config;
      };
    mkNixosConfig = config:
      nixpkgs.lib.nixosSystem
      rec {
        pkgs = mkPkgs config.system;
        modules =
          [
            config.host

            home-manager.nixosModules.home-manager
            (mkHomeManagerConfig config.home-manager)

            inputs.nix-ld.nixosModules.nix-ld
            inputs.agenix.nixosModules.default
            inputs.stylix.nixosModules.stylix
          ]
          ++ pkgs.lib.attrByPath ["extra-modules"] [] config;
      };
  in {
    homeConfigurations = {
      # lab server
      cmdline = mkHomeConfig ./home-manager/profiles/cmdline.nix;
      test = mkHomeConfig ./home-manager/profiles/test.nix;
    };

    darwinConfigurations."fr4nk1in-macbook-air" = mkDarwinConfig {
      system = "aarch64-darwin";
      home-manager = ./home-manager/profiles/darwin.nix;
    };

    nixosConfigurations = {
      wsl = mkNixosConfig {
        system = "x86_64-linux";
        host = ./hosts/wsl;
        home-manager = ./home-manager/profiles/wsl.nix;
        extra-modules = [
          nixos-wsl.nixosModules.wsl
        ];
      };

      nixos-vm = mkNixosConfig {
        system = "x86_64-linux";
        host = ./hosts/nixos-vm;
        home-manager = ./home-manager;
      };
    };
  };
}
