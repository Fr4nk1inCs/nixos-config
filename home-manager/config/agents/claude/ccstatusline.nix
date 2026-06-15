{ lib, ... }:
let
  ccstatuslineSettings = {
    version = 3;
    flexMode = "full";
    compactThreshold = 60;
    colorLevel = 2;
    defaultPadding = "";
    inheritSeparatorColors = false;
    globalBold = false;
    gitCacheTtlSeconds = 5;
    minimalistMode = true;
    powerline = {
      enabled = false;
      separators = [ "" ];
      separatorInvertBackground = [ false ];
      startCaps = [ ];
      endCaps = [ ];
      autoAlign = false;
    };
    lines =
      let
        strFalse = "false";
        strTrue = "true";

        accentColor = "cyan";
        dimmedColor = "brightBlack";

        patchId =
          prefix: items: lib.imap0 (i: item: item // { id = "${prefix}-${toString (i + 1)}"; }) items;

        andRaw = attrs: attrs // { rawValue = true; };
        andDimmed = attrs: attrs // { color = dimmedColor; };
        andAccent = attrs: attrs // { color = accentColor; };
        andMetadata = attrs: metadata: attrs // { inherit metadata; };

        mkTyped = type: { inherit type; };
        mkCommon =
          type:
          type
          |> mkTyped
          |> andDimmed
          |> andRaw;
        mkAccent =
          type:
          type
          |> mkTyped
          |> andAccent
          |> andRaw;

        mkCustomText =
          text:
          andDimmed {
            type = "custom-text";
            customText = text;
          };

        separator = {
          type = "separator";
          character = " · ";
        };
        flexSeparator = "flex-separator" |> mkTyped |> andDimmed;
      in
      lib.imap0 (i: l: patchId "line${toString i}" l) [
        [
          {
            type = "vim-mode";
            color = dimmedColor;
            metadata = {
              format = "word";
              nerdFont = strTrue;
            };
          }
          separator
          (mkAccent "model")
          (mkCustomText " (")
          (mkCommon "thinking-effort")
          (mkCustomText ")")
          separator
          (mkCommon "context-percentage")
          (mkCustomText "/")
          (mkCommon "context-window")
          (mkCustomText " ↩")
          (mkCommon "tokens-cached")
          (mkCustomText " ↑")
          (mkCommon "tokens-input")
          (mkCustomText " ↓")
          (mkCommon "tokens-output")
          (mkCustomText " 󰿺")
          (andMetadata ("compaction-counter" |> mkTyped |> andDimmed) {
            hideZero = strFalse;
            format = "number";
          })
          flexSeparator
          (andMetadata (mkCommon "current-working-dir") {
            abbreviateHome = strTrue;
            segments = "3";
          })
          separator
          (andMetadata (mkCommon "git-branch") { hideNoGit = strFalse; })
          (andMetadata (mkCommon "git-changes") { hideNoGit = strTrue; })
        ]
        [
          (andMetadata (mkAccent "session-usage") { display = "slider"; })
          (mkCustomText " ")
          (andMetadata (mkCommon "reset-timer") { compact = strTrue; })
          separator
          (andMetadata (mkAccent "weekly-usage") { display = "slider"; })
          (mkCustomText " ")
          (andMetadata (mkCommon "weekly-reset-timer") {
            compact = strTrue;
            hours = strTrue;
          })
        ]
      ];
  };
in
{
  programs.claude-code.ccstatusline = {
    enable = true;
    settings = ccstatuslineSettings;
  };
}
