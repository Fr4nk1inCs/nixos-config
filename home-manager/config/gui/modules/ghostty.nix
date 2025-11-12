{
  config,
  pkgs,
  ...
}: let
  mod =
    if pkgs.stdenv.isDarwin
    then "cmd"
    else "ctrl+shift";
in {
  config.programs.ghostty = {
    inherit (config.profile.guiSoftwares) enable;
    package =
      if pkgs.stdenv.isDarwin
      then pkgs.ghostty-bin
      else pkgs.ghostty;

    settings = {
      # font-family = "Maple Mono NF CN";
      font-feature = [
        "+calt"
        "+cv01"
        "+cv03"
        "+ss03"
      ];

      cursor-click-to-move = true;

      mouse-hide-while-typing = true;

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

      gtk-single-instance = true;
      gtk-titlebar-style = "tabs";
      gtk-titlebar-hide-when-maximized = true;

      bell-features = ["system" "no-audio" "no-attention"];

      keybind = [
        "ctrl+enter=new_split:auto"
        "${mod}+t=new_tab"
        "${mod}+e=equalize_splits"
        "${mod}+f=toggle_fullscreen"
        "${mod}+h=goto_split:left"
        "${mod}+j=goto_split:down"
        "${mod}+k=goto_split:up"
        "${mod}+l=goto_split:right"
        "global:${mod}+enter=new_window"
        "global:${mod}+backslash=toggle_quick_terminal"
      ];
    };
  };
}
