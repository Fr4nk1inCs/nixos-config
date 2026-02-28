{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    programs.agents.plugins.plannotator = {
      enable = lib.mkEnableOption "Use plannotator for opencode/claude-code";
    };
  };

  config = lib.mkIf config.programs.agents.plugins.plannotator.enable {
    home.packages = [pkgs.plannotator];

    programs.opencode = {
      settings.plugin = ["@plannotator/opencode@latest"];

      commands = {
        plannotator-review = ''
          ---
          description: Open interactive code review for current changes
          ---

          The Plannotator Code Review has been triggered. Opening the review UI...
          Acknowledge "Opening code review..." and wait for the user's feedback.
        '';
      };
    };
    programs.claude-code = {
      settings = {
        plugins = {
          "plannotator@plannotator" = true;
        };
        extraKnownMarketplaces = {
          plannotator = {
            source = "github";
            repo = "backnotprop/plannotator";
          };
        };
      };

      commands = {
        plannotator-review = ''
          ---
          description: Open interactive code review for current changes
          allowed-tools: Bash(plannotator:*)
          ---

          ## Code Review Feedback

          !`plannotator review`

          ## Your task

          Address the code review feedback above. The user has reviewed your changes in the Plannotator UI and provided specific annotations and comments.

        '';
      };
    };
  };
}
