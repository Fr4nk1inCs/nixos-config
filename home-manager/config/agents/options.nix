{
  lib,
  config,
  ...
}: {
  options = {
    programs.agents.context = lib.mkOption {
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
  };

  config = let
    cfg = config.programs.agents;
  in
    lib.mkIf (cfg.context != "")
    {
      programs = {
        opencode.context = cfg.context;
        codex.context = cfg.context;
        claude-code.context = cfg.context;
        pi-coding-agent.context = cfg.context;
      };
    };
}
