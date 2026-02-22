{pkgs, ...}: {
  imports = [
    ./oh-my-opencode.nix
  ];

  programs.opencode = {
    enable = true;
    package = pkgs.llm-agents.opencode;
  };

  programs.oh-my-opencode = {
    enable = true;
    version = "3.8.2"; # FIXME
    claude = false;
    openai = false;
    gemini = false;
    copilot = true;
  };
}
