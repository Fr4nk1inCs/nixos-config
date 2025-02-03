{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.homeManagerConfig;
  enable = cfg.gui.enable && pkgs.stdenv.isDarwin;

  aerospace = "${pkgs.aerospace}/bin/aerospace";

  # General configuration
  fonts = {
    label = "Maple Mono NF CN:Regular:12.0";
    icon = "Maple Mono NF CN:Regular:12.0";
    appIcon = "sketchybar-app-font:Regular:11.5";
  };
  colors = {
    background = {
      default = "0xff2e3440";
      lighter = "0xff444c5e";
    };
    foreground = {
      default = "0xffcdcecf";
    };
    border = "0xff5a657d";
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
      source ${sketchybarAppFontNameToIcon}

      APPICONS=""
      for APP in $APPNAMES; do
        __icon_map $APP
        APPICONS="$APPICONS$icon_result"
      done

      echo "$APPICONS"
    '';

    onWorkspaceChange = pkgs.writeShellScript "sketchybar-on-workspace-change.sh" ''
      if [ "$FOCUSED_WORKSPACE" = "" ] || [ "$PREV_WORKSPACE" = "" ]; then
        exit 0
      fi

      # set highlight
      sketchybar --set "space.$FOCUSED_WORKSPACE" icon.drawing="on"
      sketchybar --set "space.$FOCUSED_WORKSPACE" label.highlight="on"  icon.highlight="on"
      sketchybar --set "space.$PREV_WORKSPACE"    label.highlight="off" icon.highlight="off"

      # set border
      sketchybar --set "space.$FOCUSED_WORKSPACE" background.border_color="${colors.border}"
      sketchybar --set "space.$PREV_WORKSPACE"    background.border_color="${colors.background.lighter}"

      # set label
      APPICONS=$(${scripts.workspaceAppIcons} $PREV_WORKSPACE)
      if [ "$APPICONS" != "" ]; then
        sketchybar --set "space.$PREV_WORKSPACE" label.drawing="on"
        sketchybar --set "space.$PREV_WORKSPACE" label="$APPICONS"
      else
        sketchybar --set "space.$PREV_WORKSPACE" icon.drawing="off"
      fi
      sketchybar --set "space.$FOCUSED_WORKSPACE" label.drawing="off"
    '';

    sketchybarAppFontNameToIcon = "${pkgs.sketchybar-app-font}/bin/icon_map.sh";
  };

  # Sketchybar configuration
  events = ["aerospace_workspace_change"];

  workspaces = map toString (lib.range 1 10);

  mkWorkspaceConfig = space: {
    "background.height" = 20;
    "background.color" = colors.background.lighter;
    "background.border_color" = colors.background.lighter;
    "background.border_width" = 1;
    "background.corner_radius" = 4;

    icon = space;
    "icon.drawing" = "off";
    "icon.font" = fonts.label; # icon is used to display workspace number
    "icon.highlight_color" = colors.palette.blue;
    "icon.highlight" = "off";
    "icon.padding_left" = 6;
    "icon.padding_right" = 6;

    label = "";
    "label.drawing" = "off";
    "label.font" = fonts.appIcon; # label is used to display opened apps
    "label.y_offset" = 0;
    "label.highlight_color" = colors.palette.blue;
    "label.highlight" = "off";
    "label.padding_left" = 3;
    "label.padding_right" = 6;

    click_script = "${aerospace} workspace ${space}";
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

      "label.font" = fonts.label;
      "label.color" = colors.foreground.default;
      "label.padding_left" = 4;
      "label.padding_right" = 4;
    };

    workspaceBracket = {
      "background.color" = colors.background.lighter;
      "background.drawing" = "on";
      "background.corner_radius" = 4;
      "background.height" = 20;
    };

    workspaceChangeHandler = {
      script = scripts.onWorkspaceChange;
      "label.drawing" = "off";
      "icon.drawing" = "off";
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

  _mkBracketRc = {
    name,
    matches ? [],
    regex ? "",
    config,
  }: let
    matchesStr =
      if matches == []
      then "'${regex}'"
      else toString matches;
  in ''
    sketchybar --add bracket ${name} ${matchesStr} \
      --set ${name} \
      ${configToSketchybarKvPairs config}
  '';

  mkSketchybarRc = {
    type ? "default",
    config,
    name ? "",
    position ? "",
    subscriptions ? [],
    matches ? [],
    regex ? "",
  }:
    if type == "item"
    then
      _mkItemRc {
        inherit name config position subscriptions;
      }
    else if type == "bracket"
    then
      _mkBracketRc {
        inherit name matches regex config;
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
          type = "bracket";
          name = "workspaceBracket";
          config = sketchybarConfig.workspaceBracket;
          regex = "/space\\.\.*/";
        }}

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
          subscriptions = ["front_app_switched"];
        }}

        ${mkSketchybarRc {
          type = "item";
          name = "__workspaceChangeHandler";
          config = sketchybarConfig.workspaceChangeHandler;
          subscriptions = ["aerospace_workspace_change"];
          position = "right";
        }}

        sketchybar --update
      '';
    };
  };
}
