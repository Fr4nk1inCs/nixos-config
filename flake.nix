{
  description = "Fr4nk1in's NixOS / nix-darwin configuration";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # Principle Inputs ---------------------------------------------------------
    nixos-pkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    darwin-pkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    pkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixos-pkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "darwin-pkgs";
    };

    home-manager.url = "github:nix-community/home-manager/master";

    # Nix Utilities ------------------------------------------------------------
    nix-ld = {
      url = "github:nix-community/nix-ld";
      inputs.nixpkgs.follows = "nixos-pkgs";
    };

    agenix.url = "github:ryantm/agenix";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixos-pkgs";
    };

    # Software -----------------------------------------------------------------
    nixCats = {
      url = "github:Fr4nk1inCs/nixcats-nvim";
      inputs.nixpkgs.follows = "pkgs-unstable";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "pkgs-unstable";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixos-pkgs";
    };

    hunk = {
      url = "github:modem-dev/hunk";
      inputs.nixpkgs.follows = "pkgs-unstable";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "pkgs-unstable";
    };

    # Other --------------------------------------------------------------------
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };

    # Development Tools --------------------------------------------------------
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "pkgs-unstable";
    };

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "pkgs-unstable";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree ./modules
    );
}
