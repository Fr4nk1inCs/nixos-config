{
  config,
  lib,
  ...
}:
let
  inherit (config.profile.guiSoftwares) enable;
in
{
  config = {
    programs.zed-editor = {
      inherit enable;

      installRemoteServer = true;

      mutableUserDebug = true;
      mutableUserSettings = true;

      userKeymaps =
        let
          navigation = {
            "H" = "pane::ActivatePreviousItem";
            "L" = "pane::ActivateNextItem";
            "ctrl-h" = "workspace::ActivatePaneLeft";
            "ctrl-l" = "workspace::ActivatePaneRight";
            "ctrl-k" = "workspace::ActivatePaneUp";
            "ctrl-j" = "workspace::ActivatePaneDown";
          };

          finders = {
            "space s g" = "workspace::NewSearch";
            "space f e" = "project_panel::ToggleFocus";
            "space f f" = "file_finder::Toggle";
          };

          code = {
            "space g b" = "git::Blame";

            "space c a" = "editor::ToggleCodeActions";
            "space c f" = "editor::Format";
            "g d" = "editor::GoToDefinition";
            "g r a" = "editor::ToggleCodeActions";
            "g r r" = "editor::FindAllReferences";
            "g r n" = "editor::Rename";
            "g r t" = "editor::GoToTypeDefinition";
            "g r i" = "editor::GoToImplementation";
            "g p d" = "editor::GoToDefinitionSplit";
            "g p t" = "editor::GoToTypeDefinitionSplit";
            "g p i" = "editor::GoToImplementationSplit";
            "g O" = "outline::Toggle";
          };

          QOL = {
            "Y" = [
              "workspace::SendKeystrokes"
              "y $"
            ];
            "alt-d" = "editor::MoveLineDown";
            "alt-u" = "editor::MoveLineUp";
          };
        in
        [
          {
            "context" = "VimControl && !menu";
            "bindings" = {
              "space" = null;
            };
          }

          {
            context = "Workspace";
            bindings = {
              "ctrl-\\" = "terminal_panel::ToggleFocus";
            };
          }

          {
            "context" = "vim_mode == normal && !menu";
            "bindings" = {
              "b d" = "pane::CloseActiveItem";
              "b o" = "pane::CloseOtherItems";

              "space e" = "project_panel::ToggleFocus";
              "space f e" = "project_panel::ToggleFocus";
              "space f o" = "outline_panel::ToggleFocus";
            }
            // code
            // navigation
            // finders
            // QOL;
          }

          {
            "context" = "vim_mode == visual && !menu";
            "bindings" = {
              ">" = "editor::Indent";
            };
          }

          {
            "context" = "Editor";
            "bindings" = {
              "ctrl-;" = "editor::AcceptEditPrediction";
              "ctrl-[" = "copilot::PreviousSuggestion";
              "ctrl-]" = "copilot::NextSuggestion";
            };
          }

          {
            "context" = "!Editor && !Terminal";
            "bindings" = {
              "q" = "workspace::CloseActiveDock";
            }
            // finders;
          }

          {
            "context" = "!Editor && !Terminal";
            "unbind" = {
              "space f" = "file_finder::Toggle";
            };
          }

          {
            "context" = "ProjectPanel && not_editing";
            "bindings" = {
              "space e" = "workspace::CloseActiveDock";
              "space f e" = "workspace::CloseActiveDock";
              "space f o" = "outline_panel::ToggleFocus";
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
              "space f o" = "workspace::CloseActiveDock";
              "space f e" = "project_panel::ToggleFocus";
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

      userSettings =
        let
          font-features = {
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
        in
        {
          vim_mode = true;
          vim.toggle_relative_line_numbers = true;
          vim.use_system_clipboard = "always";
          which_key.enabled = true;
          which_key.delay_ms = 0;

          command_aliases = {
            W = "w";
            Wq = "wq";
            Q = "q";
          };

          title_bar.show_branch_status_icon = true;

          ui_font_family = lib.mkForce config.stylix.fonts.monospace.name;
          ui_font_features = font-features;
          ui_font_size = lib.mkForce config.stylix.fonts.sizes.terminal;
          buffer_font_features = font-features;
          buffer_font_size = lib.mkForce config.stylix.fonts.sizes.terminal;

          wrap_guides = [
            80
            120
          ];
          preferred_line_length = 80;

          edit_predictions = {
            provider = "copilot";
            mode = "eager";
            disabled_globs = [ ];
            copilot = {
              proxy = null;
              proxy_no_verify = null;
              enterprise_uri = null;
            };
          };

          agent_servers = {
            claude-acp.type = "registry";
            pi-acp.type = "registry";
          };
        };
    };
  };
}
