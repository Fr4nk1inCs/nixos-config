{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.homeManagerConfig;
  enable = cfg.gui.enable && cfg.system == "darwin";

  aerospace = "${pkgs.aerospace}/bin/aerospace";

  # General configuration
  fonts = {
    label = {
      normal = "Maple Mono NF CN:Regular:12.0";
      superScript = "Maple Mono NF CN:Regular:8.0";
    };
    icon = "Maple Mono NF CN:Regular:14.0";
    appIcon = "sketchybar-app-font:Regular:14.0";
  };
  colors = {
    background = {
      default = "0xff2e3440";
    };
    foreground = {
      default = "0xffcdcecf";
    };
    palette = {
      blue = "0xff81a1c1";
      red = "0xffbf616a";
    };
  };
  scripts = let
    colrm = "${pkgs.util-linux}/bin/colrm";
  in rec {
    currentWorkspaceTitle = pkgs.writeShellScript "current-workspace-title.sh" ''
      CURRENT_WORKSPACE=$(${aerospace} list-workspaces --focused)
      readarray -t FRONTAPPS < <(${aerospace} list-windows --workspace "$CURRENT_WORKSPACE" --format "(%{app-name}) %{window-title}")

      # Trim the results if they are too long
      for i in "''${!FRONTAPPS[@]}"; do
        if [ ''${#FRONTAPPS[$i]} -gt 40 ]; then
          FRONTAPPS[i]="$(echo "''${FRONTAPPS[i]}" | ${colrm} 41)…"
        fi
      done

      sketchybar --set spaceTitle label="''${FRONTAPPS[*]}"
    '';

    workspaceAppIcons = pkgs.writeShellScript "workspace-app-icons.sh" ''
      APPNAMES=$(${aerospace} list-windows --workspace "$1" --format "%{app-name}")

      APPICONS=""
      for APP in $APPNAMES; do
        APPICONS="$APPICONS$(${sketchybarAppFontNameToIcon} $APP) "
      done

      echo "$APPICONS"
    '';

    setWorkspaceHighlight = pkgs.writeShellScript "sketchybar-set-workspace-highlight.sh" ''
      echo "ARG: $1, Name: $NAME, Focused: $FOCUSED_WORKSPACE, Prev: $PREV_WORKSPACE"
      if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
        sketchybar --set $NAME icon.highlight="on" label.highlight="on"
      else
        sketchybar --set $NAME icon.highlight="off" label.highlight="off"
      fi
    '';

    sketchybarAppFontNameToIcon = "${pkgs.sketchybar-app-font}/bin/icon_map.sh";
  };

  # Sketchybar configuration
  events = ["aerospace_workspace_change"];

  workspaces = map toString (lib.range 1 10);
  workspaceIcons = let
    defaultIcon = "󰨇";
    specialIcons = {
      "7" = "󰝚";
      "8" = "󰚢";
    };
  in
    lib.listToAttrs (
      map (space: {
        name = space;
        value = specialIcons.${space} or defaultIcon;
      })
      workspaces
    );

  mkWorkspaceConfig = space: {
    icon = workspaceIcons.${space};
    "icon.padding_right" = 2;
    "icon.highlight_color" = colors.palette.blue;
    "icon.highlight" = "off";

    label = space;
    "label.font" = fonts.label.superScript;
    "label.y_offset" = 6;
    "label.padding_left" = 0;
    "label.highlight_color" = colors.palette.blue;
    "label.highlight" = "off";

    click_script = "${aerospace} workspace ${space}";
    script = "${scripts.setWorkspaceHighlight} ${space}";
  };

  sketchybarConfig = {
    bar = {
      height = 25;
      color = colors.background.default;
      position = "bottom";
      display = "all";
    };

    default = {
      "icon.font" = fonts.icon;
      "icon.color" = colors.foreground.default;
      "icon.padding_left" = 4;
      "icon.padding_right" = 4;

      "label.font" = fonts.label.normal;
      "label.color" = colors.foreground.default;
      "label.padding_left" = 4;
      "label.padding_right" = 4;
    };

    chevron = {
      icon = "";
      "label.drawing" = "off";
    };

    spaceTitle = {
      script = toString scripts.currentWorkspaceTitle;
      "icon.drawing" = "off";
    };
  };

  configToSketchybarKvPairs = config:
    lib.concatStringsSep " \\\n  "
    (
      lib.mapAttrsToList
      (key: value: ''${key}="${toString value}"'')
      config
    );

  _mkItemRc = {
    name,
    config,
    position,
    subscriptions ? [],
  }: let
    setSubscriptions =
      lib.optionalString (subscriptions != [])
      "--subscribe ${name} ${lib.concatStringsSep " " subscriptions} \\\n  ";
  in ''
    sketchybar --add item ${name} ${position} \
      ${setSubscriptions}--set ${name} \
      ${configToSketchybarKvPairs config}
  '';

  mkSketchybarRc = {
    type ? "default",
    config,
    name ? "",
    position ? "",
    subscriptions ? [],
  }:
    if type == "item"
    then
      _mkItemRc {
        inherit name config position subscriptions;
      }
    else ''
      sketchybar --${type} \
        ${configToSketchybarKvPairs config}
    '';

  eventsRc = lib.concatLines (map (event: "sketchybar --add event ${event}") events);

  workspacesRc = lib.concatStringsSep "\n\n" (
    map (space:
      _mkItemRc {
        name = "space.${space}";
        config = mkWorkspaceConfig space;
        position = "left";
        subscriptions = ["aerospace_workspace_change"];
      })
    workspaces
  );
in {
  config = lib.mkIf enable {
    home.packages = with pkgs; [sketchybar-app-font];
    xdg.configFile."sketchybar/sketchybarrc" = {
      executable = true;
      text = ''
        ${eventsRc}

        ${mkSketchybarRc {
          type = "bar";
          config = sketchybarConfig.bar;
        }}

        ${mkSketchybarRc {
          type = "default";
          config = sketchybarConfig.default;
        }}

        ${workspacesRc}

        ${mkSketchybarRc {
          type = "item";
          name = "chevron";
          config = sketchybarConfig.chevron;
          position = "left";
        }}

        ${mkSketchybarRc {
          type = "item";
          name = "spaceTitle";
          config = sketchybarConfig.spaceTitle;
          position = "left";
          subscriptions = ["front_app_switched" "window_focus"];
        }}

        sketchybar --update
      '';
    };
  };
}
