{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.homeManagerConfig.gui) enable;
in {
  config.programs.zed-editor = lib.mkIf enable {
    enable = true;
    extensions = [
      "nvim-nightfox"
      "nix"
    ];
    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "ctrl-\\" = "terminal_panel::ToggleFocus";
        };
      }
      {
        "context" = "vim_mode == normal && !menu";
        "bindings" = {
          # navigation
          "H" = "pane::ActivatePrevItem";
          "L" = "pane::ActivateNextItem";
          "ctrl-h" = ["workspace::ActivatePaneInDirection" "Left"];
          "ctrl-l" = ["workspace::ActivatePaneInDirection" "Right"];
          "ctrl-k" = ["workspace::ActivatePaneInDirection" "Up"];
          "ctrl-j" = ["workspace::ActivatePaneInDirection" "Down"];
          # yank
          "Y" = ["workspace::SendKeystrokes" "y $"];
          # move lines
          "alt-j" = "editor::MoveLineDown";
          "alt-k" = "editor::MoveLineUp";
          # buffer
          "b d" = "pane::CloseActiveItem";
          "b o" = "pane::CloseInactiveItems";
          # file
          "space e" = "workspace::ToggleLeftDock";
          "space f f" = "file_finder::Toggle";
          # search
          "space s g" = "workspace::NewSearch";
          "space s s" = "outline::Toggle";
          # git
          "space g b" = "editor::ToggleGitBlame";
          # lsp
          "space c d" = "editor::Hover";
        };
      }
      {
        "context" = "vim_mode == visual && !menu";
        "bindings" = {
          ">" = "editor::Indent";
        };
      }
      {
        "context" = "Editor && vim_mode == insert";
        "bindings" = {
          "ctrl-a" = "editor::AcceptInlineCompletion";
          "ctrl-[" = "copilot::PreviousSuggestion";
          "ctrl-]" = "copilot::NextSuggestion";
        };
      }
      {
        "context" = "ProjectPanel && not_editing";
        "bindings" = {
          "space e" = "workspace::ToggleLeftDock";
          "q" = "workspace::ToggleLeftDock";
        };
      }
      {
        "context" = "OutlinePanel && not_editing";
        "bindings" = {
          "space e" = "workspace::ToggleLeftDock";
        };
      }
    ];
    userSettings = {
      vim_mode = true;
      command_aliases = {
        W = "w";
        Wq = "wq";
        Q = "q";
      };
      # Appearance
      ui_font_size = 14;
      buffer_font_family = "Maple Mono NF CN";
      buffer_font_size = 12;
      buffer_font_features = {
        calt = true;
        zero = false;
        cv01 = true;
        cv02 = false;
        cv03 = false;
        cv04 = false;
        cv98 = false;
        cv99 = false;
        ss01 = false;
      };
      theme = {
        mode = "system";
        light = "Dawnfox";
        dark = "Nordfox";
      };
    };
  };
  config.home.packages = lib.optionals enable (
    with pkgs; [
      nixd
    ]
  );
}