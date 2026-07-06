{ self, ... }: {
  flake.modules.homeManager.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      stylix.targets.vscode.fonts.override = {
        sizes = lib.optionalAttrs pkgs.stdenv.isDarwin {
          terminal = config.stylix.fonts.sizes.terminal * 3.0 / 4.0;
        };
      };

      programs.vscode = {
        enable = true;
        package = with pkgs; (if stdenv.isLinux then vscode-fhs else vscode);

        profiles.default = {
          enableExtensionUpdateCheck = false;
          enableUpdateCheck = false;
          enableMcpIntegration = false;

          extensions = with pkgs.vscode-extensions; [
            ms-ceintl.vscode-language-pack-zh-hans
            # QOL
            ms-vscode-remote.vscode-remote-extensionpack
            aaron-bond.better-comments
            usernamehw.errorlens
            pkief.material-icon-theme
            eamodio.gitlens
            ms-vscode.hexeditor
            # Languages
            tombi-toml.tombi # TOML
            ## Python
            ms-python.python
            ms-python.debugpy
            ms-python.vscode-python-envs
            meta.pyrefly
            ms-toolsai.jupyter
            ms-toolsai.jupyter-renderers
            charliermarsh.ruff
            # misc
            wakatime.vscode-wakatime
          ];

          keybindings = [
            {
              "key" = "ctrl+;";
              "command" = "editor.action.inlineSuggest.commit";
              "when" =
                "inlineSuggestionHasIndentationLessThanTabSize && inlineSuggestionVisible && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible || cursorAtInlineEdit && inlineEditIsVisible && !editor.hasSelection && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible || inlineEditIsVisible && inlineSuggestionHasIndentationLessThanTabSize && inlineSuggestionVisible && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible || cursorAtInlineEdit && inlineEditIsVisible && inlineSuggestionVisible && !editor.hasSelection && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible";
            }
            {
              "key" = "tab";
              "command" = "selectNextSuggestion";
              "when" =
                "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
            }
            {
              "key" = "down";
              "command" = "-selectNextSuggestion";
              "when" =
                "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
            }
            {
              "key" = "shift+tab";
              "command" = "selectPrevSuggestion";
              "when" =
                "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
            }
            {
              "key" = "up";
              "command" = "-selectPrevSuggestion";
              "when" =
                "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
            }
            {
              "key" = "ctrl+[";
              "command" = "editor.action.inlineSuggest.showPrevious";
              "when" = "inlineSuggestionVisible && !editorReadonly";
            }
            {
              "key" = "alt+[";
              "command" = "-editor.action.inlineSuggest.showPrevious";
              "when" = "inlineSuggestionVisible && !editorReadonly";
            }
            {
              "key" = "ctrl+]";
              "command" = "editor.action.inlineSuggest.showNext";
              "when" = "inlineSuggestionVisible && !editorReadonly";
            }
            {
              "key" = "alt+]";
              "command" = "-editor.action.inlineSuggest.showNext";
              "when" = "inlineSuggestionVisible && !editorReadonly";
            }
            {
              "key" = "ctrl+q";
              "command" = "editor.action.inlineSuggest.hide";
              "when" = "inlineEditIsVisible || inlineSuggestionVisible";
            }
            {
              "key" = "escape";
              "command" = "-editor.action.inlineSuggest.hide";
              "when" = "inlineEditIsVisible || inlineSuggestionVisible";
            }
            {
              "key" = "ctrl+;";
              "command" = "editor.action.inlineSuggest.commit";
              "when" = "inInlineEditsPreviewEditor";
            }
            {
              "key" = "tab";
              "command" = "-editor.action.inlineSuggest.commit";
              "when" = "inInlineEditsPreviewEditor";
            }
            {
              "key" = "ctrl+;";
              "command" = "editor.action.inlineSuggest.commit";
              "when" =
                "inlineEditIsVisible && tabShouldAcceptInlineEdit && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible || inlineEditIsVisible && inlineSuggestionVisible && tabShouldAcceptInlineEdit && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible || inlineSuggestionHasIndentationLessThanTabSize && inlineSuggestionVisible && !editor.hasSelection && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible || inlineEditIsVisible && inlineSuggestionHasIndentationLessThanTabSize && inlineSuggestionVisible && !editor.hasSelection && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible";
            }
            {
              "key" = "tab";
              "command" = "-editor.action.inlineSuggest.commit";
              "when" =
                "inlineEditIsVisible && tabShouldAcceptInlineEdit && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible || inlineEditIsVisible && inlineSuggestionVisible && tabShouldAcceptInlineEdit && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible || inlineSuggestionHasIndentationLessThanTabSize && inlineSuggestionVisible && !editor.hasSelection && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible || inlineEditIsVisible && inlineSuggestionHasIndentationLessThanTabSize && inlineSuggestionVisible && !editor.hasSelection && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible";
            }
          ];

          userSettings =
            let
              inherit (self.lib.fontFeatures) toCssString;
            in
            {
              "[python]"."editor.defaultFormatter" = "charliermarsh.ruff";
              "editor.fontLigatures" = toCssString self.constants.fontFeatures.maple-mono;
              "editor.fontVariations" = true;
              "editor.indentSize" = "tabSize";
              "editor.lineNumbers" = "relative";
              "editor.suggest.selectionMode" = "never";
              "editor.tabSize" = 2;
              "editor.wordWrap" = "off";
              "explorer.confirmDragAndDrop" = false;
              "files.associations".authorized_keys = "ssh_config";
              "git.allowForcePush" = true;
              "git.autofetch" = true;
              "git.confirmForcePush" = false;
              "git.confirmSync" = false;
              "git.enableSmartCommit" = true;
              "github.copilot.enable" = {
                "*" = true;
                "scminput" = false;
              };
              "github.copilot.nextEditSuggestions.enabled" = true;
              "jupyter.widgetScriptSources" = [
                "jsdelivr.com"
                "unpkg.com"
              ];
              "notebook.lineNumbers" = "on";
              "python.languageServer" = "None";
              "python.pyrefly.syncNotebooks" = true;
              "python.pyrefly.typeCheckingMode" = "default";
              "ruff.lineLength" = 80;
              "security.promptForRemoteFileProtocolHandling" = false;
              "security.workspace.trust.untrustedFiles" = "open";
              "window.titleBarStyle" = "custom";
              "workbench.iconTheme" = "material-icon-theme";
              "workbench.sideBar.location" = "right";
              "workbench.view.showQuietly"."workbench.panel.output" = true;
            };
        };
      };
    };
}
