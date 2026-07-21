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

        kimiScript = pkgs.writeShellApplication {
          name = "kimi-herdr-agent-state";
          text = ''
            bash '${herdrIntegrationAssets}/kimi/herdr-agent-state.sh' "''${1}"
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

        kimi-code.settings.hooks =
          let
            script = lib.getExe kimiScript;
            mkHerdrHook = event: mode: {
              inherit event;
              command = "${script} ${mode}";
              timeout = 10;
            };
          in
          [
            (mkHerdrHook "SessionStart" "session")
            (mkHerdrHook "UserPromptSubmit" "working")
            (mkHerdrHook "PreToolUse" "working")
            (mkHerdrHook "SubagentStart" "working")
            (mkHerdrHook "PreCompact" "working")
            (mkHerdrHook "PermissionRequest" "blocked")
            (mkHerdrHook "PermissionResult" "working")
            (mkHerdrHook "Stop" "idle")
            (mkHerdrHook "Interrupt" "idle")
          ];
      };
  };
}
