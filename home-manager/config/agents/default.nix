{pkgs, ...}: {
  imports = [
    ./plugins
    ./pi-coding-agent
  ];

  programs = {
    # opencode = {
    #   enable = true;
    #   package = pkgs.llm-agents.opencode;
    #   context = ./AGENTS.md;
    #   settings = {
    #     plugin = [
    #       "@franlol/opencode-md-table-formatter@latest"
    #       "@tarquinen/opencode-dcp@latest"
    #     ];
    #   };
    # };

    pi-coding-agent = {
      enable = true;
      context = ./AGENTS.md;
      extensions = {
        footer = ./pi-coding-agent/extensions/footer.ts;
      };
    };

    claude-code = {
      enable = true;
      package = pkgs.llm-agents.claude-code;
      context = ./AGENTS.md;
      ccstatusline = {
        enable = true;
        settings = import ./claude/ccstatusline.nix;
      };
    };

    agents.plugins = {
      superpowers.enable = true;
    };
  };
}
