{ inputs, ... }:
{
  flake.modules.homeManager.agents =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs = {
        claude-code = {
          enable = true;
          mutableSettings = true;
          configDir = "${config.xdg.configHome}/claude";

          settings = {
            model = "opus";

            theme = "auto";
            tui = "fullscreen";

            permissions.defaultMode = "auto";
            autoMemoryEnabled = false;

            statusLine =
              let
                pythonPydantic = pkgs.python3.withPackages (ps: [ ps.pydantic ]);
                python = lib.getExe pythonPydantic;
              in
              {
                type = "command";
                command = "${python} ${./assets/claude-code/statusline.py}";
              };
          };
        };

        pi-coding-agent = {
          enable = true;
          mutableSettings = true;
          configDir = "${config.xdg.configHome}/pi/agent";

          extraPackages = with pkgs; [ nodejs ];

          settings = {
            defaultThinkingLevel = "medium";
            defaultProjectTrust = "always";

            theme = "system";
            tuiMode = "fullscreen";
            editorPaddingX = 0;
            outputPad = 0;
            markdown.codeBlockIndent = "";

            sessionDir = "${config.xdg.stateHome}/pi/agent/sessions";

            packages = [
              "npm:@hk_net/pi-usage-bars"
              "npm:@eko24ive/pi-ask"
              "npm:@narumitw/pi-btw"
              "npm:pi-herdr-subagents"
              "git:github.com/Fr4nk1inCs/pi-kimi-web-tools"
            ];
          };

          extensions = {
            footer = ./assets/pi-coding-agent/footer.ts;
            pi-openai-web-search = ./assets/pi-coding-agent/pi-openai-web-search.ts;
          };
        };

        codex = {
          enable = true;
          mutableSettings = true;

          settings = {
            model = "gpt-6-astra";
            model_reasoning_effort = "medium";
            approvals_reviewer = "auto_review";
            web_search = "live";

            tui = {
              status_line = [
                "model-with-reasoning"
                "current-dir"
                "git-branch"
                "branch-changes"
                "context-used"
                "used-tokens"
                "total-input-tokens"
                "total-output-tokens"
              ];
              status_line_use_colors = false;
              theme = "base16-256";
            };
          };
        };

        agents = {
          skills = {
            hunk-review = "${pkgs.hunk}/share/skills/hunk/hunk-review";
            asd-ste100 = "${inputs.asd-ste100-skill}";
          };
        };
      };
    };
}
