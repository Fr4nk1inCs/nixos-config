{
  config,
  pkgs,
  ...
}: {
  config.programs.ghostty = {
    inherit (config.homeManagerConfig.gui) enable;
    package =
      if pkgs.ghostty.meta.broken
      then null
      else pkgs.ghostty;

    settings = {
      theme = "nordfox";

      font-family = "Maple Mono NF CN";
      font-feature = [
        "+calt"
        "+cv01"
        "+cv03"
        "+ss03"
      ];
      font-size = 11;

      cursor-click-to-move = true;

      mouse-hide-while-typing = true;

      background-opacity = 0.8;
      background-blur = 20;

      link-url = true;

      window-vsync = true;
      window-padding-balance = true;

      clipboard-read = "allow";
      clipboard-write = "allow";
      clipboard-trim-trailing-spaces = true;

      quick-terminal-position = "top";
      quick-terminal-screen = "mouse";
      quick-terminal-animation-duration = 0.2;
      quick-terminal-autohide = true;
      quick-terminal-space-behavior = "move";

      shell-integration-features = ["cursor" "sudo" "title" "ssh-terminfo"];

      macos-titlebar-style = "transparent";
      macos-titlebar-proxy-icon = "hidden";
      macos-option-as-alt = true;

      keybind = [
        "cmd+t=new_tab"
        "ctrl+shift+t=new_tab"
        "ctrl+enter=new_split:auto"
        "cmd+e=equalize_splits"
        "cmd+f=toggle_fullscreen"
        "cmd+h=goto_split:left"
        "cmd+j=goto_split:down"
        "cmd+k=goto_split:up"
        "cmd+l=goto_split:right"
        "global:cmd+enter=new_window"
        "global:cmd+backslash=toggle_quick_terminal"
      ];
    };

    themes = {
      nordfox = {
        background = "2e3440";
        foreground = "cdcecf";

        selection-background = "3e4a5b";
        selection-foreground = "cdcecf";
        cursor-color = "cdcecf";

        palette = [
          # normal
          "0=#3b4252"
          "1=#bf616a"
          "2=#a3be8c"
          "3=#ebcb8b"
          "4=#81a1c1"
          "5=#b48ead"
          "6=#88c0d0"
          "7=#e5e9f0"

          # bright
          "8=#465780"
          "9=#d06f79"
          "10=#b1d196"
          "11=#f0d399"
          "12=#8cafd2"
          "13=#c895bf"
          "14=#93ccdc"
          "15=#e7ecf4"

          # extended colors
          "16=#c9826b"
        ];
      };
    };
  };
}
