{pkgs, ...}: let
  buildOmoConfigs = pkgs.stdenvNoCC.mkDerivation {
    pname = "oh-my-opencode-configs";
    version = "2026-02-10";

    src = null;

    buildInputs = with pkgs; [bun];

    buildCommand = ''
      mkdir -p $out/fakehome/.config/opencode

      HOME=$out/fakehome bunx oh-my-opencode@latest install \
        --no-tui \
        --claude=no \
        --openai=no \
        --gemini=yes \
        --copilot=yes \
        --skip-auth

      mv $out/fakehome/.config/opencode/opencode.json $out/opencode.json
      mv $out/fakehome/.config/opencode/oh-my-opencode.json $out/oh-my-opencode.json
    '';
  };

  opencode.json = builtins.readFile "${buildOmoConfigs}/opencode.json";
  oh-my-opencode.json = builtins.readFile "${buildOmoConfigs}/oh-my-opencode.json";
in {
  programs.opencode = {
    enable = true;
    package = pkgs.llm-agents.opencode;
    settings = builtins.fromJSON opencode.json;
  };

  xdg.configFile."opencode/oh-my-opencode.json".text = oh-my-opencode.json;
}
