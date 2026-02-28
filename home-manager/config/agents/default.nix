{pkgs, ...}: {
  imports = [
    ./plugins
  ];

  programs.opencode = {
    enable = true;
    package = pkgs.llm-agents.opencode;
    settings = {
      plugin = [
        "@franlol/opencode-md-table-formatter@latest"
        "@tarquinen/opencode-dcp@latest"
      ];
    };
  };

  programs.agents.plugins = {
    plannotator.enable = true;
    superpowers.enable = true;
  };
}
