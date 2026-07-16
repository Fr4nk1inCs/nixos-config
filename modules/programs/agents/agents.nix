{
  inputs,
  ...
}:
{
  flake.modules.homeManager.agents = { config, pkgs, ... }: {
    programs = {
      pi-coding-agent = {
        enable = true;
        configDir = "${config.xdg.configHome}/pi/agent";
        extraPackages = [ pkgs.nodejs ];
        settings = {
          defaultProvider = "ustc-mlsys-openai";
          defaultModel = "gpt-5.6-sol";
          theme = "light";
          defaultThinkingLevel = "high";
          packages = [
            "npm:@juicesharp/rpiv-todo"
            "npm:@juicesharp/rpiv-ask-user-question"
            "npm:@juicesharp/rpiv-btw"
            "npm:@gotgenes/pi-subagents"
            "git:github.com/code-yeongyu/pi-openai-web-search"
          ];
        };
        extensions = {
          footer = ./assets/pi-coding-agent/footer.ts;
        };
      };

      codex = {
        enable = true;
        settings = {
          model = "gpt-5.6-sol";
          model_reasoning_effort = "high";
          disable_response_storage = true;
          network_access = "enabled";
          approvals_reviewer = "auto_review";

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

      claude-code = {
        enable = true;
        configDir = "${config.xdg.configHome}/claude";
        settings = {
          theme = "light";
          editorMode = "vim";
          defaultMode = "auto";
          effortLevel = "high";
          model = "opus";
          tui = "fullscreen";

          autoMemoryEnabled = false;
          autoMode.allow = [
            "$defaults"
            "Any tool installation and invocation that happens in a isolated environment (e.g. nix shell)"
          ];
        };
      };

      agents = {
        context = ./assets/AGENTS.md;

        skills =
          let
            skills = pkgs.stdenvNoCC.mkDerivation {
              name = "skills";
              src = inputs.mattpocock-skills;
              buildInputs = with pkgs; [ findutils ];

              installPhase = ''
                runHook preInstall

                mkdir -p $out/skills
                find $src/skills/productivity $src/skills/engineering \
                  -mindepth 1 \
                  -maxdepth 1 \
                  -type d \
                  -exec cp -r {} $out/skills \;
                cp -r ${pkgs.llm-agents.hunk}/skills/hunk-review $out/skills

                runHook postInstall
              '';
            };
          in
          "${skills}/skills";
      };
    };
  };
}
