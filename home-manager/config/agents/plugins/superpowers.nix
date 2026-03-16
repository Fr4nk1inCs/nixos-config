{
  inputs,
  config,
  lib,
  ...
}: let
  superpowers = rec {
    src = inputs.superpowers;
    skills = "${src}/skills";
    opencode-plugin = "${src}/.opencode/plugins/superpowers.js";
  };
in {
  options = {
    programs.agents.plugins.superpowers = {
      enable = lib.mkEnableOption "Use superpowers for opencode/codex/claude-code";
    };
  };

  config = lib.mkIf config.programs.agents.plugins.superpowers.enable {
    xdg.configFile."opencode/plugins/superpowers.js" = {
      source = superpowers.opencode-plugin;
    };

    programs = {
      opencode = {
        skills = {
          superpowers = superpowers.skills;
        };
      };

      codex.skills.superpowers = superpowers.skills;

      claude-code.settings = {
        plugins = {
          "superpowers@claude-plugins-official" = true;
        };
      };
    };
  };
}
