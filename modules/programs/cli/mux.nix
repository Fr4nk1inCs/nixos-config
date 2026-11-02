{ inputs, ... }:
{
  flake.modules.nixos.cli = {
    imports = [ inputs.rex.nixosModules.default ];

    services.rex = {
      socketMode = "0600";
      tailscaleServe.enable = true;
    };
  };

  flake.modules.homeManager.cli = {
    imports = [ inputs.rex.homeManagerModules.default ];

    programs = {
      rex.enable = true;

      herdr = {
        enable = true;

        settings = {
          onboarding = false;
          experimental = {
            pane_history = true;
            kitty_graphics = true;
            # switch_ascii_input_source_in_prefix = true;
          };
          theme = {
            name = "terminal";
            auto_switch = false;
          };
          ui = {
            pane_scrollbars = false;
            toast.delivery = "terminal";
            show_agent_labels_on_pane_borders = true;
          };
        };
      };
    };
  };
}
