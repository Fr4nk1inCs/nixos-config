{
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
      settings = {
        editorMode = "vim";
        defaultMode = "auto";
        effortLevel = "high";
        model = "opus";
        tui = "fullscreen";

        autoMode.allow = [
          "$defaults"
          "Any tool installation and invocation that happens in a isolated environment (e.g. nix shell)"
        ];
      };
    };

    agents = {
      context = ./AGENTS.md;
    };
  };
}
