{
  inputs,
  ...
}:
let
  mkAgenix =
    pkgs: inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  flake.modules = {
    nixos.agenix = { pkgs, ... }: {
      imports = [
        inputs.agenix.nixosModules.default
      ];

      environment.systemPackages = [ (mkAgenix pkgs) ];
    };

    darwin.agenix = { pkgs, ... }: {
      imports = [
        inputs.agenix.darwinModules.default
      ];

      environment.systemPackages = [ (mkAgenix pkgs) ];
    };

    homeManager.agenix = { pkgs, config, ... }: {
      imports = [
        inputs.agenix.homeManagerModules.default
      ];

      home.packages = [ (mkAgenix pkgs) ];

      age.secretsDir = "${config.xdg.stateHome}/agenix";
    };
  };
}
