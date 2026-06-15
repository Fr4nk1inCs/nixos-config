{
  lib,
  config,
  ...
}:
{
  options = {
    programs.agents = {
      context = lib.mkOption {
        type = lib.types.either lib.types.lines lib.types.path;
        default = "";
        description = ''
          Global context for coding agents.

          The value is either:
          - Inline content as a string
          - A path to a file containing the content

          The configured content is written to enabled agents'
          AGENTS.md/CLAUDE.md or equivalent files.
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
        description = ''
          Custom skills for coding agents.

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
          symlinked into the {file}`skills/` subdirectory of enabled agents
        '';
      };
    };
  };

  config =
    let
      cfg = config.programs.agents;
      agents = [
        "opencode"
        "codex"
        "claude-code"
        "pi-coding-agent"
      ];
      checks = {
        context = i: i != "";
        skills = i: i != { };
      };
      perAgentConfig = builtins.mapAttrs (name: check: lib.mkIf (check cfg.${name}) cfg.${name}) checks;
    in
    {
      programs = builtins.listToAttrs (
        map (agent: {
          name = agent;
          value = perAgentConfig;
        }) agents
      );
    };
}
