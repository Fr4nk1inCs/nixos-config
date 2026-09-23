{
  self,
  lib,
  ...
}:
let
  username = "fr4nk1in";
in
{
  flake.modules = lib.mkMerge [
    (self.lib.createUser username true)
    {
      homeManager.${username} =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        let
          inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;

          piEnabled = config.programs.pi-coding-agent.enable;
          piConfigDir = config.programs.pi-coding-agent.configDir;

          codexEnabled = config.programs.codex.enable;
          codexConfigDir =
            if config.home.preferXdgDirectories then
              "${config.xdg.configHome}/codex"
            else
              "${config.home.homeDirectory}/.codex";

          mergePiAuth = pkgs.writeScript "merge-pi-auth" ''
            #!${pkgs.python3}/bin/python3
            import json
            from pathlib import Path
            from tempfile import TemporaryDirectory

            auth = Path(${builtins.toJSON "${piConfigDir}/auth.json"})
            base = Path(${builtins.toJSON config.age.secrets.pi-auth.path})
            existing = json.loads(auth.read_text()) if auth.exists() else {}
            merged = existing | json.loads(base.read_text())

            auth.parent.mkdir(parents=True, exist_ok=True)
            with TemporaryDirectory(prefix=".auth-merge.", dir=auth.parent) as directory:
                temporary = Path(directory) / "auth.json"
                temporary.write_text(json.dumps(merged, indent=2) + "\n")
                temporary.chmod(0o600)
                temporary.replace(auth)
          '';
        in
        {
          imports = with self.modules.homeManager; [
            system-desktop
          ];

          programs.git.settings.user = {
            name = "Fr4nk1in";
            email = "fushen@mail.ustc.edu.cn";
          };

          home.activation = {
            codexOpenaiProfile = lib.mkIf codexEnabled (
              lib.hm.dag.entryAfter [ "linkGeneration" ] ''
                run mkdir -p ${lib.escapeShellArg codexConfigDir}
                run touch ${lib.escapeShellArg "${codexConfigDir}/openai.config.toml"}
              ''
            );
          };

          systemd.user.services.agenix = lib.mkIf (piEnabled && isLinux) {
            Service.ExecStartPost = [ "${mergePiAuth}" ];
          };

          launchd.agents.activate-agenix = lib.mkIf (piEnabled && isDarwin) {
            config.ProgramArguments = lib.mkBefore [
              "${pkgs.bash}/bin/bash"
              "-c"
              ''"$1" && ${mergePiAuth}''
              "agenix-with-pi-auth"
            ];
          };

          age.secrets = {
            fr4nk1in-ed25519 = {
              file = self.lib.getAgeSource "fr4nk1in-ed25519.age";
              path = "${config.home.homeDirectory}/.ssh/fr4nk1in-ed25519";
              mode = "0600";
              symlink = false;
            };
            whisk = {
              file = self.lib.getAgeSource "whisk.age";
              path = "${config.home.homeDirectory}/.ssh/whisk";
              mode = "0600";
              symlink = false;
            };
            sshconfig-lab = {
              file = self.lib.getAgeSource "sshconfig-lab.age";
              path = "${config.home.homeDirectory}/.ssh/config.d/lab";
            };
            sshconfig-personal = {
              file = self.lib.getAgeSource "sshconfig-personal.age";
              path = "${config.home.homeDirectory}/.ssh/config.d/personal";
            };

            atuin-key = lib.optionalAttrs config.programs.atuin.enable {
              file = self.lib.getAgeSource "atuin-key.age";
              path = config.programs.atuin.settings.key_path;
              mode = "0600";
              symlink = false;
            };
            wakatime-cfg =
              let
                hasWakatime = lib.elem pkgs.wakatime-cli config.home.packages;
              in
              lib.optionalAttrs hasWakatime {
                file = self.lib.getAgeSource "wakatime-cfg.age";
                path = "${config.home.homeDirectory}/.wakatime.cfg";
                mode = "0600";
                symlink = false;
              };
            pi-auth = lib.optionalAttrs piEnabled {
              file = self.lib.getAgeSource "pi-auth.age";
              path = "${piConfigDir}/auth-base.json";
            };
            pi-mlsys-provider = lib.optionalAttrs piEnabled {
              file = self.lib.getAgeSource "pi-mlsys-provider.age";
              path = "${piConfigDir}/extensions/mlsys-provider.ts";
            };
            codex-mlsys-profile = lib.optionalAttrs codexEnabled {
              file = self.lib.getAgeSource "codex-mlsys-profile.age";
              path = "${codexConfigDir}/mlsys.config.toml";
            };
          };
        };
    }
  ];
}
