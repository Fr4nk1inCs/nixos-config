{pkgs, ...}: {
  imports = [
    ./plugins
  ];

  programs = {
    opencode = {
      enable = true;
      package = pkgs.llm-agents.opencode;
      settings = {
        plugin = [
          "@franlol/opencode-md-table-formatter@latest"
          "@tarquinen/opencode-dcp@latest"
        ];
      };
    };

    claude-code = {
      enable = true;
      package = pkgs.llm-agents.claude-code;
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
