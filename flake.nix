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
    self,
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
    mkHomeManagerConfig = profile: {
      home-manager = {
        extraSpecialArgs = {inherit self;};
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [nixvim.homeManagerModules.nixvim];
        users.${user} = import profile;
      };
    };
    mkHomeConfig = profile:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit self;};
        modules = [
          nixvim.homeManagerModules.nixvim
          profile
        ];
      };
  in {
    darwinConfigurations."fushen-mac" = nix-darwin.lib.darwinSystem {
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
      sf = mkHomeConfig "${self}/home-manager/profiles/sf.nix";
      fushen = mkHomeConfig "${self}/home-manager/profiles/fushen.nix";
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
