{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.profile.guiSoftwares) enable;
in {
  config = {
    home.packages = lib.optionals enable (with pkgs; [zed-editor nixd nixfmt-classic]);

    xdg.configFile."zed/keymap.json".text = builtins.toJSON [
      {
        context = "Workspace";
        bindings = {"ctrl-\\" = "terminal_panel::ToggleFocus";};
      }
      {
        "context" = "vim_mode == normal && !menu";
        "bindings" = {
          # navigation
          "H" = "pane::ActivatePreviousItem";
          "L" = "pane::ActivateNextItem";
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-l" = "workspace::ActivatePaneRight";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-j" = "workspace::ActivatePaneDown";
          # yank
          "Y" = ["workspace::SendKeystrokes" "y $"];
          # move lines
          "alt-j" = "editor::MoveLineDown";
          "alt-k" = "editor::MoveLineUp";
          # buffer
          "b d" = "pane::CloseActiveItem";
          "b o" = "pane::CloseInactiveItems";
          # file
          "space e" = "project_panel::ToggleFocus";
          "space f e" = "project_panel::ToggleFocus";
          "space s e" = "outline_panel::ToggleFocus";
          "space f f" = "file_finder::Toggle";
          # search
          "space s g" = "workspace::NewSearch";
          "space s s" = "outline::Toggle";
          # git
          "space g b" = "git::Blame";
          # code
          "space c d" = "editor::Hover";
          "space c f" = "editor::Format";
          "space c a" = "editor::ToggleCodeActions";
          "space c r" = "editor::Rename";
          "g d" = "editor::GoToDefinition";
          "g p d" = "editor::GoToDefinitionSplit";
          "g r" = "editor::FindAllReferences";
          "g y" = "editor::GoToTypeDefinition";
          "g p y" = "editor::GoToTypeDefinitionSplit";
          "g I" = "editor::GoToImplementation";
          "g p I" = "editor::GoToImplementationSplit";
        };
      }
      {
        "context" = "vim_mode == visual && !menu";
        "bindings" = {">" = "editor::Indent";};
      }
      {
        "context" = "Editor";
        "bindings" = {
          "ctrl-a" = "editor::AcceptEditPrediction";
          "ctrl-[" = "copilot::PreviousSuggestion";
          "ctrl-]" = "copilot::NextSuggestion";
        };
      }
      {
        "context" = "ProjectPanel && not_editing";
        "bindings" = {
          "space e" = "workspace::ToggleLeftDock";
          "space s e" = "outline_panel::ToggleFocus";
          "q" = "workspace::ToggleLeftDock";
          "a" = "project_panel::NewFile";
          "A" = "project_panel::NewDirectory";
          "x" = "project_panel::Cut";
          "y" = "project_panel::Copy";
          "p" = "project_panel::Paste";
          "d" = "project_panel::Delete";
          "r" = "project_panel::Rename";
        };
      }
      {
        "context" = "OutlinePanel && not_editing";
        "bindings" = {
          "space e" = "project_panel::ToggleFocus";
          "space f e" = "project_panel::ToggleFocus";
          "space s e" = "workspace::ToggleLeftDock";
          "q" = "workspace::ToggleLeftDock";
        };
      }
      {
        "context" = "Editor && (showing_code_actions || showing_completions)";
        "bindings" = {
          "enter" = "editor::ConfirmCompletionInsert";
          "tab" = "editor::ContextMenuNext";
          "shift-tab" = "editor::ContextMenuPrevious";
          "up" = "editor::ContextMenuPrevious";
          "down" = "editor::ContextMenuNext";
          "ctrl-p" = "editor::ContextMenuPrevious";
          "ctrl-n" = "editor::ContextMenuNext";
        };
      }
    ];

    # user settings should be modifiable since zed constantly updates it
    # xdg.configFile."zed/settings.json".text = {
    #   vim_mode = true;
    #   relative_line_numbers = true;
    #   command_aliases = {
    #     W = "w";
    #     Wq = "wq";
    #     Q = "q";
    #   };
    #   # Appearance
    #   ui_font_size = 14;
    #   buffer_font_family = "Maple Mono NF CN";
    #   buffer_font_size = 11;
    #   buffer_font_features = {
    #     calt = true;
    #     zero = false;
    #     cv01 = true;
    #     cv02 = false;
    #     cv03 = false;
    #     cv04 = false;
    #     cv98 = false;
    #     cv99 = false;
    #     ss01 = false;
    #   };
    #   theme = {
    #     mode = "system";
    #     light = "Dawnfox";
    #     dark = "Nordfox";
    #   };
    #   tab_size = 2;
    #   wrap_guides = [80 120];
    #   # code
    #   preferred_line_length = 80;
    # };
  };
}
