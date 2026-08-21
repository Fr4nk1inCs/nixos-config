_: {
  flake.modules.homeManager.agents = { config, pkgs, ... }: {
    programs = {
      pi-coding-agent = {
        enable = true;
        configDir = "${config.xdg.configHome}/pi/agent";
        extraPackages = [ pkgs.nodejs ];
        settings = {
          defaultProvider = "kimi-coding";
          defaultModel = "k3-256k";
          defaultThinkingLevel = "high";
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
            "npm:@tintinweb/pi-subagents"
            "git:github.com/code-yeongyu/pi-openai-web-search"
            "git:github.com/Fr4nk1inCs/pi-kimi-web-tools"
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

        skills = {
          hunk-review = "${pkgs.hunk}/share/skills/hunk/hunk-review";
        };
      };
    };
  };
}
