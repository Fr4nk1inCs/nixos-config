{
  self,
  inputs,
  lib,
  ...
}:
{
  options.flake = {
    lib = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = { };
    };
  };

  config = {
    flake.lib = rec {
      mkPkgs =
        system:
        import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = system == "x86_64-linux";
          };
          overlays = [
            (import ../../packages)
            inputs.llm-agents.overlays.default
          ];
        };

      mkNixOs = system: name: {
        ${name} = inputs.nixpkgs.lib.nixosSystem {
          pkgs = mkPkgs system;
          modules = [
            inputs.self.modules.nixos.${name}
          ];
        };
      };

      mkDarwin = system: name: {
        ${name} = inputs.nix-darwin.lib.darwinSystem {
          pkgs = mkPkgs system;
          modules = [
            inputs.self.modules.darwin.${name}
          ];
        };
      };

      mkHomeManager = system: name: {
        ${name} = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          modules = [
            inputs.self.modules.homeManager.${name}
          ];
        };
      };

      createUser = username: isAdmin: {
        nixos.${username} =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            users.users.${username} = {
              isNormalUser = true;
              home = "/home/${username}";
              extraGroups =
                (lib.optionals isAdmin [
                  "wheel"
                ])
                ++ config.users.commonExtraGroups;

              shell =
                if config.users.defaultUserShell == "/bin/sh" then
                  pkgs.zsh
                else
                  config.users.defaultUserShell;
            };

            nix.settings.trusted-users = [ username ];

            home-manager.users.${username} = {
              imports = [
                inputs.self.modules.homeManager.${username}
              ];
            };
          };

        darwin.${username} = { lib, pkgs, ... }: {
          users.users.${username} = {
            home = "/Users/${username}";
            shell = pkgs.zsh;
          };

          nix.settings.trusted-users = [ username ];

          system.primaryUser = lib.mkIf isAdmin "${username}";

          home-manager.users.${username} = {
            imports = [
              inputs.self.modules.homeManager.${username}
            ];
          };
        };

        homeManager.${username} = {
          home.username = username;
        };
      };

      getAgeSource = filename: self.constants.rootPath + "/secrets/${filename}";
      getAsset = filename: self.constants.rootPath + "/assets/${filename}";

      fontFeatures = rec {
        toHarfBuzz = ff: ((map (s: "+${s}") ff.on) ++ (map (s: "-${s}") ff.off));
        toBooleanAttrs =
          ff:
          builtins.listToAttrs (
            (map (s: {
              name = s;
              value = true;
            }) ff.on)
            ++ (map (s: {
              name = s;
              value = false;
            }) ff.off)
          );
        toKeyValues = ff: ((map (s: "${s}=1") ff.on) ++ (map (s: "${s}=0") ff.off));
        toFontSettings =
          ff: quotation:
          (map (s: "${quotation}${s}${quotation} on") ff.on)
          ++ (map (s: "${quotation}${s}${quotation} off") ff.off);
        toFontConfig =
          ff: indentation:
          lib.concatLines (
            map (fontSetting: "${indentation}<string>${fontSetting}</string>") (
              toFontSettings ff ""
            )
          );
      };
    };
  };
}
