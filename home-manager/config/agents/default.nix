{
  pkgs,
  config,
  ...
}: let
  pi-coding-agent = pkgs.symlinkJoin {
    name = "pi-coding-agent";
    buildInputs = [pkgs.makeWrapper];
    paths = [pkgs.pi-coding-agent];
    postBuild = ''
      wrapProgram $out/bin/pi \
        --set NPM_CONFIG_PREFIX ${config.home.homeDirectory}/.pi/npm/ \
        --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.nodejs]}
    '';
  };
in {
  imports = [
    ./options.nix
    ./plugins
    ./pi-coding-agent
  ];

  programs = {
    pi-coding-agent = {
      enable = true;
      package = pi-coding-agent;
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
        model = "claude-opus-4-7";
        tui = "fullscreen";

        autoMode.allow = [
          "$defaults"
          "Any tool installation and invocation that happens in a isolated environment (e.g. nix shell)"
        ];
      };
      ccstatusline = {
        enable = true;
        settings = import ./claude/ccstatusline.nix;
      };
    };

    agents = {
      context = ./AGENTS.md;
    };
  };
}
