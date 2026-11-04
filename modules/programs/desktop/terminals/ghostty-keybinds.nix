{
  flake.modules.homeManager.desktop =
    { lib, pkgs, ... }:
    let
      leader =
        if pkgs.stdenv.hostPlatform.isDarwin then
          "super+semicolon"
        else
          "ctrl+semicolon";

      bind =
        key: actions:
        [ "${key}=${builtins.head actions}" ]
        ++ map (action: "chain=${action}") (builtins.tail actions);
      exit = [ "deactivate_all_key_tables" ];
      enter = name: exit ++ [ "activate_key_table:${name}" ];
      once = action: exit ++ [ action ];

      group =
        name: bindings:
        lib.concatLists (
          lib.mapAttrsToList (key: bind "${name}/${key}") (
            {
              escape = exit;
              "ctrl+c" = exit;
              catch_all = [ "ignore" ];
            }
            // bindings
          )
        );

      focus = {
        h = once "goto_split:left";
        j = once "goto_split:down";
        k = once "goto_split:up";
        l = once "goto_split:right";
      };
    in
    {
      programs.ghostty.settings.keybind =
        bind leader (enter "leader")
        ++ group "leader" (
          focus
          // {
            backspace = exit;
            "shift+semicolon" = once "toggle_command_palette";
            minus = once "new_split:down";
            "shift+backslash" = once "new_split:right";
            "shift+r" = once "reload_config";
            w = enter "windows";
            tab = enter "tabs";
          }
        )
        ++ group "windows" (
          focus
          // {
            backspace = enter "leader";
            d = once "close_surface";
            m = once "toggle_split_zoom";
            equal = once "equalize_splits";
            r = enter "resize";
          }
        )
        ++ group "resize" {
          backspace = enter "windows";
          enter = exit;
          i = exit;
          q = exit;
          equal = [ "equalize_splits" ];
          "ctrl+semicolon" = [ "toggle_command_palette" ];
          # Plain action lists keep the group active. Resize amounts are pixels.
          h = [ "resize_split:left,5" ];
          j = [ "resize_split:down,5" ];
          k = [ "resize_split:up,5" ];
          l = [ "resize_split:right,5" ];
          "shift+h" = [ "resize_split:left,15" ];
          "shift+j" = [ "resize_split:down,15" ];
          "shift+k" = [ "resize_split:up,15" ];
          "shift+l" = [ "resize_split:right,15" ];
        }
        ++ group "tabs" {
          backspace = enter "leader";
          tab = once "new_tab";
          bracket_left = once "previous_tab";
          bracket_right = once "next_tab";
          f = once "goto_tab:1";
          l = once "last_tab";
          d = once "close_tab:this";
        };
    };
}
