{ self, inputs, ... }:
let
  magpie-key = [
    {
      id = "73b4c8a976dc9b4fb87e3ac4";
      name = "All in One";
      secret = "magpie-key";
    }
  ];
  magpie-settings = {
    theme = "system";
    lang = "system";
    tray = "panel";
    currency = "usd";
    otel = { };
    updateEvery = 360;
    trayUsageEvery = 3;
    plainNames = true;
    textSize = 110;
  };
in
{
  flake.modules = {
    nixos.agents =
      {
        config,
        pkgs,
        ...
      }:
      let
        jsonFormat = pkgs.formats.json { };
        magpie-mount = "/etc/magpie";
      in
      {
        age.secrets.magpie-env-file.file = self.lib.getAgeSource "magpie-env-file.age";
        age.secrets.magpie-providers = {
          file = self.lib.getAgeSource "magpie-providers.age";
          owner = "65532";
          group = "65532";
          mode = "0400";
        };

        systemd.tmpfiles.rules = [
          "d ${magpie-mount} 0755 65532 65532 -"
        ];

        virtualisation.oci-containers = {
          backend = "docker";

          containers = {
            magpie = {
              image = "ghcr.io/yetone/magpie:latest";

              cmd = [
                "web"
                "--addr"
                "0.0.0.0:3430"
                "--no-open"
              ];

              ports = [
                "127.0.0.1:3425:3425"
                "127.0.0.1:3430:3430"
              ];

              volumes = [
                "${jsonFormat.generate "settings.json" magpie-settings}:/config/magpie/settings.json:ro"
                "${jsonFormat.generate "caller-keys.json" magpie-key}:/config/magpie/caller-keys.json:ro"
                "${config.age.secrets.magpie-providers.path}:/config/magpie/providers.json:ro"
                "${magpie-mount}:/config/magpie"
              ];

              environmentFiles = [
                config.age.secrets.magpie-env-file.path
              ];
            };
          };
        };
      };

    darwin.agents = {
      homebrew.casks = [ "yetone/magpie-releases/magpie-app" ];
    };

    homeManager.agents =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      let
        claude-settings = lib.importJSON ./assets/magpie/claude.json;
        pi-models = lib.importJSON ./assets/magpie/pi-models.json;

        jsonFormat = pkgs.formats.json { };
      in
      {
        programs = {
          claude-code = {
            enable = true;
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

              # Magpie
              inherit (claude-settings) modelPicker;

              env = {
                inherit (claude-settings.env)
                  CLAUDE_CODE_MODEL_CAPABILITIES
                  CLAUDE_CODE_AUTO_MODE_SERVER
                  ANTHROPIC_AUTH_TOKEN
                  ANTHROPIC_BASE_URL
                  ;

                ANTHROPIC_DEFAULT_FABLE_MODEL = "auto/gpt-6-astra";
                ANTHROPIC_DEFAULT_OPUS_MODEL = "auto/gpt-6-astra";
                ANTHROPIC_DEFAULT_SONNET_MODEL = "auto/gpt-6-luna";
                ANTHROPIC_DEFAULT_HAIKU_MODEL = "auto/gpt-6-luna";
                ANTHROPIC_SMALL_FAST_MODEL = "auto/gpt-6-luna";
              };
            };
          };

          pi-coding-agent = {
            enable = true;
            configDir = "${config.xdg.configHome}/pi/agent";
            extraPackages = with pkgs; [ nodejs ];

            settings = {
              defaultProvider = "magpie";
              defaultModel = "auto/gpt-6-astra";
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

            models = pi-models;

            extensions = {
              footer = ./assets/pi-coding-agent/footer.ts;
              pi-openai-web-search = ./assets/pi-coding-agent/pi-openai-web-search.ts;
            };
          };

          codex = {
            enable = true;
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

        age.secrets.magpie-providers = {
          file = self.lib.getAgeSource "magpie-providers.age";
          path = "${config.xdg.configHome}/magpie/providers.json";
        };

        xdg.configFile = {
          "codex/magpie.codex.toml".source = ./assets/magpie/codex.toml;
          "magpie/settings.json".source =
            jsonFormat.generate "settings.json" magpie-settings;
          "magpie/caller-keys.json".source =
            jsonFormat.generate "caller-keys.json" magpie-key;
        };
      };
  };
}
