{
  flake.modules.homeManager.cli = { pkgs, lib, ... }: {
    programs =
      let
        herdrSrc = pkgs.herdr.src;
        herdrIntegrationAssets = "${herdrSrc}/src/integration/assets";

        claudeScript = pkgs.writeShellApplication {
          name = "claude-herdr-agent-state";
          text = ''
            bash '${herdrIntegrationAssets}/claude/herdr-agent-state.sh' session
          '';
          runtimeInputs = with pkgs; [ python3 ];
        };

        codexScript = pkgs.writeShellApplication {
          name = "codex-herdr-agent-state";
          text = ''
            bash '${herdrIntegrationAssets}/codex/herdr-agent-state.sh' session
          '';
          runtimeInputs = with pkgs; [ python3 ];
        };
      in
      {
        herdr = {
          enable = true;

          settings = {
            onboarding = false;
            experimental = {
              pane_history = true;
              kitty_graphics = true;
              # switch_ascii_input_source_in_prefix = true;
            };
            theme = {
              name = "terminal";
              auto_switch = false;
            };
            ui = {
              toast.delivery = "terminal";
              show_agent_labels_on_pane_borders = true;
            };
          };
        };

        pi-coding-agent.extensions.herdr-agent-state = "${herdrIntegrationAssets}/pi/herdr-agent-state.ts";

        codex.hooks.SessionStart = [
          {
            command = lib.getExe codexScript;
            timeout = 10;
            type = "command";
          }
        ];

        claude-code.settings.hooks.SessionStart = [
          {
            hooks = [
              {
                command = lib.getExe claudeScript;
                timeout = 10;
                type = "command";
              }
            ];
            matcher = "*";
          }
        ];
      };
  };
}
