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

      kimi-code = {
        enable = true;
        configDir = "${config.xdg.configHome}/kimi-code";
        settings =
          let
            oauth = {
              storage = "file";
              key = "oauth/kimi-code";
            };
          in
          {
            default_model = "kimi-code/k3";
            default_permission_mode = "yolo";
            thinking = {
              enabled = true;
              effort = "max";
              keep = "all";
            };

            providers = {
              "managed:kimi-code" = {
                type = "kimi";
                api_key = "";
                base_url = "https://api.kimi.com/coding/v1";
                inherit oauth;
              };
            };

            models = {
              "kimi-code/k3" = {
                provider = "managed:kimi-code";
                model = "k3";
                max_context_size = 1048576;
                capabilities = [
                  "thinking"
                  "always_thinking"
                  "image_in"
                  "video_in"
                  "tool_use"
                ];
                display_name = "K3";
                support_efforts = [
                  "low"
                  "high"
                  "max"
                ];
                default_effort = "high";
              };

              "kimi-code/kimi-for-coding" = {
                provider = "managed:kimi-code";
                model = "kimi-for-coding";
                max_context_size = 262144;
                capabilities = [
                  "thinking"
                  "always_thinking"
                  "image_in"
                  "video_in"
                  "tool_use"
                ];
                display_name = "K2.7 Coding";
              };

              "kimi-code/kimi-for-coding-highspeed" = {
                provider = "managed:kimi-code";
                model = "kimi-for-coding-highspeed";
                max_context_size = 262144;
                capabilities = [
                  "thinking"
                  "always_thinking"
                  "image_in"
                  "video_in"
                  "tool_use"
                ];
                display_name = "K2.7 Coding Highspeed";
              };
            };

            services = {
              moonshot_search = {
                base_url = "https://api.kimi.com/coding/v1/search";
                api_key = "";
                inherit oauth;
              };
              moonshot_fetch = {
                base_url = "https://api.kimi.com/coding/v1/fetch";
                api_key = "";
                inherit oauth;
              };
            };
          };

        tui = {
          upgrade.auto_install = false;
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
