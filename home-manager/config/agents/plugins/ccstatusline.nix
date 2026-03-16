{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    programs.claude-code.ccstatusline = {
      enable = lib.mkEnableOption "Use ccstatusline in claude-code";
    };
  };

  config = let
    cfg = config.programs.claude-code.ccstatusline;
    ccstatusline = lib.getExe pkgs.llm-agents.ccstatusline;
  in
    lib.mkIf cfg.enable {
      home.packages = [pkgs.llm-agents.ccstatusline];
      programs.claude-code.settings.statusLine = {
        type = "command";
        command = toString ccstatusline;
        padding = 0;
      };
    };
}
