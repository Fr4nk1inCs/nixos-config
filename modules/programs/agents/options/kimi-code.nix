{
  flake.modules.homeManager.agents =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.programs.kimi-code;

      tomlFormat = pkgs.formats.toml { };
      jsonFormat = pkgs.formats.json { };

      upstreamConfigDir = "${config.home.homeDirectory}/.kimi-code";

      isStorePathString =
        content:
        builtins.isString content && lib.hasPrefix "${builtins.storeDir}/" content;
      isPathLikeContent = content: lib.isPath content || isStorePathString content;

      skillsArePath = isPathLikeContent cfg.skills;
      skillsAreDirectory = skillsArePath && lib.pathIsDirectory cfg.skills;

      mkSkillEntry =
        name: content:
        if isPathLikeContent content && lib.pathIsDirectory content then
          lib.nameValuePair "${cfg.configDir}/skills/${name}" {
            source = content;
            recursive = true;
          }
        else
          lib.nameValuePair "${cfg.configDir}/skills/${name}/SKILL.md" (
            if isPathLikeContent content then { source = content; } else { text = content; }
          );
    in
    {
      options.programs.kimi-code = {
        enable = lib.mkEnableOption "Kimi Code, Moonshot's official CLI";

        package = lib.mkPackageOption pkgs [ "llm-agents" "kimi-code" ] {
          nullable = true;
        };

        configDir = lib.mkOption {
          type = lib.types.str;
          default = upstreamConfigDir;
          defaultText = lib.literalExpression ''"''${config.home.homeDirectory}/.kimi-code"'';
          example = lib.literalExpression ''"''${config.xdg.configHome}/kimi-code"'';
          description = ''
            Directory holding Kimi Code's configuration and data files.

            Defaults to {file}`~/.kimi-code`, matching the upstream
            {command}`kimi` CLI default. The {env}`KIMI_CODE_HOME`
            environment variable is exported automatically whenever the
            directory differs from this default so the CLI reads
            configuration from the same location.
          '';
        };

        settings = lib.mkOption {
          inherit (tomlFormat) type;
          default = { };
          example = lib.literalExpression ''
            {
              default_model = "kimi-code/kimi-for-coding";
              default_permission_mode = "manual";
              telemetry = false;

              providers."managed:kimi-code" = {
                type = "kimi";
                base_url = "https://api.kimi.com/coding/v1";
              };

              models."kimi-code/kimi-for-coding" = {
                provider = "managed:kimi-code";
                model = "kimi-for-coding";
                max_context_size = 262144;
              };

              thinking = {
                enabled = true;
                effort = "high";
              };

              permission.rules = [
                { decision = "allow"; pattern = "Read"; }
                { decision = "deny"; pattern = "Bash(rm -rf*)"; }
              ];

              hooks = [
                {
                  event = "PreToolUse";
                  matcher = "Bash";
                  command = "node ~/.kimi-code/hooks/check-bash.mjs";
                  timeout = 5;
                }
              ];
            }
          '';
          description = ''
            TOML configuration written to {file}`config.toml` inside
            {option}`programs.kimi-code.configDir`, covering agent and
            runtime settings such as `default_model`, `providers`,
            `models`, `thinking`, `loop_control`, `permission.rules`
            and lifecycle `hooks`.

            Field names use snake_case. Attribute names containing `.`
            must be quoted (e.g. `models."gpt-4.1"`), matching TOML
            table syntax.

            See <https://www.kimi.com/code/docs/en/kimi-code-cli/configuration/config-files.html>
            for the documentation.
          '';
        };

        tui = lib.mkOption {
          inherit (tomlFormat) type;
          default = { };
          example = lib.literalExpression ''
            {
              theme = "light";

              notifications = {
                enabled = true;
                notification_condition = "unfocused";
              };

              upgrade.auto_install = false;
            }
          '';
          description = ''
            TOML configuration written to {file}`tui.toml` inside
            {option}`programs.kimi-code.configDir`, holding terminal-UI
            and client preferences (theme, editor, notifications,
            auto-update).

            Kimi Code keeps these in a separate file from
            {option}`programs.kimi-code.settings`, so interactive
            commands like {command}`/theme` or {command}`/editor`
            rewrite {file}`tui.toml` instead of the main configuration.

            See <https://www.kimi.com/code/docs/en/kimi-code-cli/configuration/config-files.html#tui-toml>
            for the documentation.
          '';
        };

        context = lib.mkOption {
          type = lib.types.either lib.types.lines lib.types.path;
          default = "";
          example = lib.literalExpression "./agents-context.md";
          description = ''
            Global context for Kimi Code.

            The value is either:
            - Inline content as a string
            - A path to a file containing the content

            The configured content is written to
            {file}`AGENTS.md` inside {option}`programs.kimi-code.configDir`
            (default {file}`~/.kimi-code/AGENTS.md`), which Kimi Code
            loads as global agent instructions.
          '';
        };

        skills = lib.mkOption {
          type = lib.types.either (lib.types.attrsOf (
            lib.types.oneOf [
              lib.types.lines
              lib.types.path
              lib.types.str
            ]
          )) lib.types.path;
          default = { };
          example = lib.literalExpression ''
            {
              pdf-processing = '''
                ---
                name: pdf-processing
                description: Extract text and tables from PDF files
                ---

                # PDF Processing
              ''';
              data-analysis = ./skills/data-analysis;
            }
          '';
          description = ''
            Custom skills for Kimi Code.

            This option can be either:
            - An attribute set defining skills
            - A path to a directory containing skill folders

            If an attribute set is used, the attribute name becomes the
            skill directory name, and the value is either:
            - Inline content as a string (creates {file}`skills/<name>/SKILL.md`)
            - A path to a file (creates {file}`skills/<name>/SKILL.md`)
            - A path to a directory (creates {file}`skills/<name>/` with all files)

            This also accepts Nix store paths, for example a skill directory
            from a package.

            If a path is used, it is expected to contain one folder per
            skill name, each containing a {file}`SKILL.md`. The directory is
            symlinked into the {file}`skills/` subdirectory of
            {option}`programs.kimi-code.configDir`.

            See <https://www.kimi.com/code/docs/en/kimi-code-cli/customization/skills.html>
            for more details.
          '';
        };

        mcpServers = lib.mkOption {
          type = lib.types.attrsOf jsonFormat.type;
          default = { };
          example = {
            filesystem = {
              command = "npx";
              args = [
                "-y"
                "@modelcontextprotocol/server-filesystem"
                "/tmp"
              ];
            };
            linear = {
              url = "https://mcp.linear.app/mcp";
            };
            legacy-events = {
              transport = "sse";
              url = "https://mcp.example.com/sse";
            };
          };
          description = ''
            MCP (Model Context Protocol) servers configuration, written
            as the top-level `mcpServers` object of {file}`mcp.json`
            inside {option}`programs.kimi-code.configDir`.

            Entries with a `command` field are stdio servers; entries
            with a `url` field default to HTTP servers; set
            `transport = "sse"` for legacy SSE servers.

            See <https://www.kimi.com/code/docs/en/kimi-code-cli/customization/mcp.html>
            for more details.
          '';
        };

        themes = lib.mkOption {
          type = lib.types.attrsOf jsonFormat.type;
          default = { };
          example = {
            ember = {
              name = "ember";
              base = "dark";
              colors = {
                primary = "#83A598";
                accent = "#FE8019";
              };
            };
          };
          description = ''
            Custom themes for Kimi Code.

            The attribute name becomes the theme filename, and the value
            is the theme definition. Themes are written to
            {file}`themes/<name>.json` inside
            {option}`programs.kimi-code.configDir` and appear as
            `Custom: <name>` in the {command}`/theme` picker. Select one
            by setting `theme` in
            {option}`programs.kimi-code.tui`.

            See <https://www.kimi.com/code/docs/en/kimi-code-cli/customization/themes.html>
            for more details.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        assertions = [
          {
            assertion = !skillsArePath || skillsAreDirectory;
            message = "`programs.kimi-code.skills` must be a directory when set to a path";
          }
        ];

        home = {
          packages = lib.mkIf (cfg.package != null) [ cfg.package ];

          sessionVariables = lib.mkIf (cfg.configDir != upstreamConfigDir) {
            KIMI_CODE_HOME = cfg.configDir;
          };

          file = lib.mkMerge [
            (lib.mkIf (cfg.settings != { }) {
              "${cfg.configDir}/config.toml".source =
                tomlFormat.generate "kimi-code-config.toml" cfg.settings;
            })

            (lib.mkIf (cfg.tui != { }) {
              "${cfg.configDir}/tui.toml".source =
                tomlFormat.generate "kimi-code-tui.toml" cfg.tui;
            })

            (
              if isPathLikeContent cfg.context then
                { "${cfg.configDir}/AGENTS.md".source = cfg.context; }
              else
                (lib.mkIf (cfg.context != "") {
                  "${cfg.configDir}/AGENTS.md".text = cfg.context;
                })
            )

            (lib.mkIf (cfg.mcpServers != { }) {
              "${cfg.configDir}/mcp.json".source = jsonFormat.generate "kimi-code-mcp.json" {
                inherit (cfg) mcpServers;
              };
            })

            (lib.mapAttrs' (
              name: theme:
              lib.nameValuePair "${cfg.configDir}/themes/${name}.json" {
                source = jsonFormat.generate "kimi-code-theme-${name}.json" theme;
              }
            ) cfg.themes)

            (lib.mkIf skillsArePath {
              "${cfg.configDir}/skills" = {
                source = cfg.skills;
                recursive = true;
              };
            })

            (lib.optionalAttrs (!skillsArePath) (lib.mapAttrs' mkSkillEntry cfg.skills))
          ];
        };
      };
    };
}
