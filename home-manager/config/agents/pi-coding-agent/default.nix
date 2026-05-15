{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.programs.pi-coding-agent;

  jsonFormat = pkgs.formats.json {};

  isStorePathString = content: builtins.isString content && lib.hasPrefix "${builtins.storeDir}/" content;
  isPathLikeContent = content: lib.isPath content || isStorePathString content;
in {
  options = {
    programs.pi-coding-agent = {
      enable = lib.mkEnableOption "pi-mono coding agent";

      package = lib.mkPackageOption pkgs "pi-coding-agent" {nullable = true;};

      settings = lib.mkOption {
        inherit (jsonFormat) type;
        default = {};
        example = {
          defaultProvider = "deepseek";
          defaultModel = "deepseek-v4-pro";
          defaultThinkingLevel = "medium";
        };
        description = ''
          Configuration written to {file}`$HOME/.pi/agent/settings.json`.
          See <https://pi.dev/docs/latest/settings> for more details.
        '';
      };

      keybindings = lib.mkOption {
        inherit (jsonFormat) type;
        default = {};
        example = {
          "tui.editor.cursorUp" = ["up" "ctrl+p"];
          "tui.editor.cursorDown" = ["down" "ctrl+n"];
          "tui.editor.deleteWordBackward" = ["ctrl+w" "alt+backspace"];
        };
        description = ''
          Keybindings written to {file}`$HOME/.pi/agent/keybindings.json`.
          See <https://pi.dev/docs/latest/keybindings> for more details.
        '';
      };

      context = lib.mkOption {
        type = lib.types.either lib.types.lines lib.types.path;
        default = "";
        description = ''
          Global context for pi-coding-agent.

          The value is either:
          - Inline content as a string
          - A path to a file containing the content

          The configured content is written to
          {file}`$HOME/.pi/agent/AGENTS.md`.
        '';
      };

      customSystemPrompt = {
        enable = lib.mkEnableOption "Enable custom system prompt for pi-coding-agent";

        content = lib.mkOption {
          type = lib.types.either lib.types.lines lib.types.path;
          default = "";
          description = ''
            System prompt for pi-coding-agent.

            The value is either:
            - Inline content as a string
            - A path to a file containing the content
          '';
        };

        mode = lib.mkOption {
          type = lib.types.enum ["replace" "append"];
          default = "replace";
          description = ''
            How to apply the system prompt.

            - `replace`: Replace the default system prompt with the provided content.
              The configured content is written to {file}`$HOME/.pi/agent/SYSTEM.md`.
            - `append`: Append the provided content to the default system prompt.
              The configured content is written to {file}`$HOME/.pi/agent/APPEND_SYSTEM.md`.
          '';
        };
      };

      skills = lib.mkOption {
        type =
          lib.types.either (lib.types.attrsOf (
            lib.types.oneOf [
              lib.types.lines
              lib.types.path
              lib.types.str
            ]
          ))
          lib.types.path;
        default = {};
        description = ''
          Custom skills for Opencode.

          This option can be either:
          - An attribute set defining skills
          - A path to a directory containing skill folders

          If an attribute set iis used, the attribute name becomes the skill
          directory name, and the value is either:
          - Inline content as a string (creates `skills/<name>/SKILL.md`)
          - A path to a file (creates `skills/<name>/SKILL.md`)
          - A path to a directory (creates `skills/<name>/` with all files)

          This also accepts Nix store paths, for example a skill directory from
          a package.

          If a path is used, it is expected to contain one folder per skill
          name, each containing a {file}`SKILL.md`. The directory is symlinked
          to {file}`$HOME/.pi/agent/skills/`.

          See <https://pi.dev/docs/latest/skills> for more details.
        '';
      };

      extensions = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.oneOf [
            lib.types.lines
            lib.types.path
            lib.types.str
          ]
        );
        default = {};
        description = ''
          Custom extensions for pi-coding-agent.

          The attribute name becomes the extension filename, and the value is either:
          - Inline content as a string (creates `extensions/<name>.ts`)
          - A path to a file (creates `extensions/<name>.ts`)

          The configured extensions are written to
          {file}`$HOME/.pi/agent/extensions/` with one file per extension.

          See <https://pi.dev/docs/latest/extensions> for more details.
        '';
      };

      promptTemplates = lib.mkOption {
        type =
          lib.types.either (lib.types.attrsOf (
            lib.types.oneOf [
              lib.types.lines
              lib.types.path
              lib.types.str
            ]
          ))
          lib.types.path;
        default = {};
        description = ''
          Custom prompt templates for pi-coding-agent.

          This option can be either:
          - An attribute set defining prompt templates
          - A path to a directory containing prompt template files

          If an attribute set is used, the attribute name becomes the prompt
          template filename, and the value is either:
          - Inline content as a string (creates `prompts/<name>.md`)
          - A path to a file (creates `prompts/<name>.md`)

          This also accepts Nix store paths, for example a prompt template
          directory from a package.

          If a path is used, it is expected to contain prompt template files.
          The directory is symlinked to {file}`$HOME/.pi/agent/prompts/`.

          See <https://pi.dev/docs/latest/prompt-templates> for more details.
        '';
      };

      themes = lib.mkOption {
        type =
          lib.types.either (lib.types.attrsOf (
            lib.types.either jsonFormat.type lib.types.path
          ))
          lib.types.path;
        default = {};
        description = ''
          Custom themes for pi-coding-agent.

          This option can be either:
          - An attribute set defining themes
          - A path to a directory containing multiple theme files

          If an attribute set is used, the attribute name becomes the theme
          filename, and the value is either:
          - An attribute set thet is converted to a JSON file (creates `themes/<name>.json`)
          - A path to a file (creates `themes/<name>.json`)

          If a path is used, it is expected to contain theme files.
          The directory is symlinked to {file}`$HOME/.pi/agent/themes/`.

          See <https://pi.dev/docs/latest/themes> for more details.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !isPathLikeContent cfg.skills || lib.pathIsDirectory cfg.skills;
        message = "`programs.pi-coding-agent.skills` must be a directory when set to a path.";
      }
      {
        assertion = !isPathLikeContent cfg.promptTemplates || lib.pathIsDirectory cfg.promptTemplates;
        message = "`programs.pi-coding-agent.promptTemplates` must be a directory when set to a path.";
      }
      {
        assertion = !isPathLikeContent cfg.themes || lib.pathIsDirectory cfg.themes;
        message = "`programs.pi-coding-agent.themes` must be a directory when set to a path.";
      }
    ];

    home.packages = lib.mkIf (cfg.package != null) [cfg.package];

    home.file = let
      prefix = ".pi/agent";
      linkOrCreate = content:
        if isPathLikeContent content
        then {source = content;}
        else if content != ""
        then {text = content;}
        else {enable = false;};

      buildNamedDirectory = dirname: content: extension:
        lib.mapAttrs' (
          name: subitem:
            lib.nameValuePair "${prefix}/${dirname}/${name}${extension}" (
              linkOrCreate subitem
            )
        )
        content;

      linkOrBuildNamedDirectory = dirname: content: extension:
        if isPathLikeContent content then {
          "${prefix}/${dirname}" = {
            source = content;
            recursive = true;
          };
        } else if builtins.isAttrs content then
          buildNamedDirectory dirname content extension
        else {};
    in
      {
        "${prefix}/settings.json" = lib.mkIf (cfg.settings != {}) {
          source = jsonFormat.generate "settings.json" cfg.settings;
        };

        "${prefix}/keybindings.json" = lib.mkIf (cfg.keybindings != {}) {
          source = jsonFormat.generate "keybindings.json" cfg.keybindings;
        };

        "${prefix}/AGENTS.md" = linkOrCreate cfg.context;

        "${prefix}/SYSTEM.md" =
          if cfg.customSystemPrompt.enable && cfg.customSystemPrompt.mode == "replace"
          then linkOrCreate cfg.customSystemPrompt.content
          else {enable = false;};

        "${prefix}/APPEND_SYSTEM.md" =
          if cfg.customSystemPrompt.enable && cfg.customSystemPrompt.mode == "append"
          then linkOrCreate cfg.customSystemPrompt.content
          else {enable = false;};
      }
      // linkOrBuildNamedDirectory "extensions" cfg.extensions ".ts"
      // linkOrBuildNamedDirectory "skills" cfg.skills ".md"
      // linkOrBuildNamedDirectory "prompts" cfg.promptTemplates ".md"
      // linkOrBuildNamedDirectory "themes" cfg.themes ".json";
  };
}
