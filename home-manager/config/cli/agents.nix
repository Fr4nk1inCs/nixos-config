_: {
  programs.opencode = {
    enable = true;
    settings = {
      plugin = [
        "oh-my-opencode"
        "opencode-gemini-auth@latest"
      ];
    };
  };

  xdg.configFile = {
    "opencode/oh-my-opencode.json".text = builtins.toJSON {
      "$schema" = "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json";
      google_auth = true;
      agents = {
        Sisyphus.model = "github-copilot/claude-sonnet-4.5";
        Builder-Sisyphus.model = "github-copilot/gpt-5.1-codex-max";
        Planner-Sisyphus.model = "github-copilot/gpt-5.2";
        librarian.model = "google/gemini-3-flash";
        explore.model = "google/gemini-3-flash";
        frontend-ui-ux-engineer.model = "google/gemini-3-pro-high";
        document-writer.model = "google/gemini-3-flash";
        multimodal-looker.model = "google/gemini-3-flash";
      };
    };
  };
}
