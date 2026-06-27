{
  flake.modules.homeManager.cli = { pkgs, lib, ... }: {
    programs =
      let
        herdrSrc = pkgs.herdr.src;
        herdrIntegrationAssets = "${herdrSrc}/src/integration/assets";
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

        claude-code =
          let
            script = pkgs.writeShellApplication {
              name = "herdr-agent-state";
              text = ''
                bash '${herdrIntegrationAssets}/claude/herdr-agent-state.sh' session
              '';
              runtimeInputs = with pkgs; [ python3 ];
            };
          in
          {
            settings = {
              hooks.SessionStart = [
                {
                  hooks = [
                    {
                      command = lib.getExe script;
                      timeout = 10;
                      type = "command";
                    }
                  ];
                  matcher = "*";
                }
              ];
            };
          };
      };

  };
}
