{ self, inputs, ... }:
{
  flake.modules.homeManager.agents =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (pkgs.stdenv) hostPlatform;
      inherit (hostPlatform) isLinux;
      inherit (inputs.xyenon-nur.packages.${hostPlatform.system}) magpie;
    in
    {
      home.packages = [ magpie ];

      systemd.user.services.magpie = lib.mkIf isLinux {
        Unit = {
          Description = "Magpie agent gateway";
          Requires = [ "agenix.service" ];
          After = [ "agenix.service" ];
        };
        Service = {
          ExecStart = "${lib.getExe magpie} web --addr 127.0.0.1:3430 --no-open";
          WorkingDirectory = config.home.homeDirectory;
          Environment = [
            "HOME=${config.home.homeDirectory}"
            "XDG_CONFIG_HOME=${config.xdg.configHome}"
            "XDG_CACHE_HOME=${config.xdg.cacheHome}"
            "XDG_DATA_HOME=${config.xdg.dataHome}"
            "XDG_STATE_HOME=${config.xdg.stateHome}"
            "CLAUDE_CONFIG_DIR=${config.programs.claude-code.configDir}"
            "PI_CODING_AGENT_DIR=${config.programs.pi-coding-agent.configDir}"
            "CODEX_HOME=${
              config.home.sessionVariables.CODEX_HOME or "${config.home.homeDirectory}/.codex"
            }"
            "PATH=${config.home.profileDirectory}/bin:/run/current-system/sw/bin"
            "MAGPIE_ADDR=127.0.0.1:3425"
          ];
          EnvironmentFile = config.age.secrets.magpie-env-file.path;
          Restart = "on-failure";
          RestartSec = 5;
        };
        Install.WantedBy = [ "default.target" ];
      };

      age.secrets = {
        magpie-env-file = lib.mkIf isLinux {
          file = self.lib.getAgeSource "magpie-env-file.age";
        };

        magpie-providers = {
          file = self.lib.getAgeSource "magpie-providers.age";
          path = "${config.xdg.configHome}/magpie/providers.json";
        };
      };
    };
}
