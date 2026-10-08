{ inputs, ... }: {
  flake.modules.homeManager.agents =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      skillRuntime = [
        pkgs.python3
        pkgs.nodejs
      ];
      asdSte100Skill = pkgs.runCommand "asd-ste100-skill" { } ''
        cd ${inputs.asd-ste100-skill}/videos/ep01-the-cure-for-ai-slop/asd-ste100
        mkdir -p "$out/hooks"
        cp -r SKILL.md LICENSE references scripts "$out/"
        cp hooks/run-python.cjs "$out/hooks/"
      '';
    in
    {
      programs = {
        pi-coding-agent = {
          enable = true;
          configDir = "${config.xdg.configHome}/pi/agent";
          extraPackages = skillRuntime;
          settings = {
            defaultProvider = "openai";
            defaultModel = "gpt-6-astra";
            defaultThinkingLevel = "medium";
            defaultProjectTrust = "always";

            theme = "light";
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
          package = pkgs.symlinkJoin {
            name = "codex-with-skill-runtime";
            paths = [ pkgs.codex ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram "$out/bin/codex" \
                --prefix PATH : ${lib.makeBinPath skillRuntime}
            '';
            inherit (pkgs.codex) meta version;
          };
          settings = {
            model = "gpt-6-astra";
            model_reasoning_effort = "medium";
            disable_response_storage = true;
            network_access = "enabled";
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
          context = ./assets/AGENTS.md;

          skills = {
            hunk-review = "${pkgs.hunk}/share/skills/hunk/hunk-review";
            asd-ste100 = "${asdSte100Skill}";
          };
        };
      };
    };
}
