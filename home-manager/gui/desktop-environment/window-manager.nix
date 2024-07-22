{pkgs, ...}: let
  mod = "super";
  terminal = "kitty";
in {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      general = {
        sensitivity = 1.0;

        # layout
        layout = "dwindle";

        # border
        border_size = 2;
        "col.inactive_border" = "rgba(4c566aff)"; # Nord gray
        "col.active_border" = "rgba(81a1c1ff)"; # Nord blue
        "col.nogroup_border" = "rgba(4c566aff)"; # Nord gray
        "col.nogroup_border_active" = "rgba(81a1c1ff)"; # Nord blue

        # margin/gap
        gaps_in = 5;
        gaps_out = 5;

        # MISC
        resize_on_border = true;
      }; # general

      input = {
        numlock_by_default = true;
        repeat_rate = 25;
        repeat_delay = 300;
        natural_scroll = false;

        touchpad = {
          disable_while_typing = true;
          natural_scroll = true;
          clickfinger_behavior = true;
          tab-to-click = true;
        };
      }; # input

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_min_speed_to_force = 5;
      }; # gestures

      decorations = {
        # rounded corners
        rounding = 10;

        # transparent background
        active_opacity = 0.95;
        inactive_opacity = 0.95;
        fullscreen_opacity = 1.0;

        # blur
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
        };

        # shadow
        drop_shadow = true;
        shadow_range = 5;
        shadow_rander_power = 2;
        shadow_ignore_window = true;
        shadow_offset = [0 0];
        shadow_scale = 1.0;

        # dim
        dim_inactive = true;
        dim_strength = 0.1;
      }; # decorations

      "bezier" = "overshot, 0.05, 0.9, 0.1, 1.05";
      animations = {
        enabled = true;

        animation = [
          "window, 1, 4, overshot, popin"
          "fade, 1, 4, overshot"
          "workspaces, 1, 4, overshot, popin"
        ];
      }; # animations

      # layout configuration
      dwindle = {
        pseudotile = true;
        force_split = 0;
      }; # dwindle
      master = {
        mfact = 0.6;
        new_on_top = true;
        new_is_master = false;
        no_gaps_when_only = true;
      }; # master

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
      };
    };
  };
}
