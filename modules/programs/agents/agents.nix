{
  inputs,
  lib,
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
          defaultProvider = "xiaomi";
          defaultModel = "mimo-v2.5-pro";
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
            subpath2attr = path: {
              name = lib.last (lib.splitString "/" path);
              value = path;
            };
            MattPocockSkillPath = subpath: "${inputs.mattpocock-skills}/skills/${subpath}";
            MattPocockSkills = builtins.mapAttrs (_: MattPocockSkillPath) (
              builtins.listToAttrs (
                map subpath2attr [
                  "productivity/grill-me"
                  "productivity/teach"
                  "productivity/handoff"
                  "engineering/grill-with-docs"
                  "engineering/tdd"
                  "engineering/to-issues"
                  "engineering/to-prd"
                ]
              )
            );
          in
          {
            hunk-review = "${
              inputs.hunk.packages.${pkgs.stdenv.hostPlatform.system}.hunk
            }/skills/hunk-review";
          }
          // MattPocockSkills;
      };
    };
  };
}
