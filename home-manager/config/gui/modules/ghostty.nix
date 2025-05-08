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

      shell-integration-features = ["cursor" "sudo" "title"];

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
  };
}
