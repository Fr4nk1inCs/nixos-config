{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./options.nix
    ./plugins
    ./pi-coding-agent
    ./claude/ccstatusline.nix
  ];

  programs = {
    pi-coding-agent = {
      enable = true;
      configDir = "${config.xdg.configHome}/pi/agent";
      extraPackages = [pkgs.nodejs];
      settings = {
        defaultProvider = "xiaomi";
        defaultModel = "mimo-v2.5-pro";
        theme = "light";
        defaultThinkingLevel = "high";
        packages = [
          "npm:@ff-labs/pi-fff"
        ];
      };
      extensions = {
        footer = ./pi-coding-agent/extensions/footer.ts;
      };
    };

    claude-code = {
      enable = true;
      package = pkgs.llm-agents.claude-code;
      configDir = "${config.xdg.configHome}/claude";
      settings = {
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
      context = ./AGENTS.md;

      skills = let
        subpath2attr = path: {
          name = lib.last (lib.splitString "/" path);
          value = path;
        };
        MattPocockSkills = subpath: "${inputs.mattpocock-skills}/skills/${subpath}";
      in
        builtins.mapAttrs (_: MattPocockSkills) (
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
    };
  };
}
