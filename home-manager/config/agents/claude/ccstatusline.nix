{
  version = 3;
  flexMode = "full-minus-40";
  compactThreshold = 60;
  colorLevel = 1;
  defaultPadding = " ";
  inheritSeparatorColors = false;
  globalBold = false;
  powerline = {
    enabled = false;
    separators = [""];
    separatorInvertBackground = [false];
    startCaps = [];
    endCaps = [];
    theme = "nord-aurora";
    autoAlign = false;
  };
  lines = [
    [
      {
        id = "1";
        type = "vim-mode";
        color = "white";
        metadata = {
          format = "word";
        };
      }
      {
        id = "2";
        type = "current-working-dir";
        color = "blue";
        rawValue = true;
        metadata = {
          "abbreviateHome" = "true";
          "segments" = "3";
        };
      }
      {
        id = "3";
        type = "git-branch";
        color = "magenta";
        metadata = {
          "hideNoGit" = "true";
        };
      }
      {
        id = "4";
        type = "git-changes";
        color = "yellow";
        metadata = {
          "hideNoGit" = "true";
        };
      }
    ]
    [
      {
        id = "5";
        type = "model";
        color = "green";
        rawValue = true;
      }
      {
        id = "6";
        type = "context-bar";
        color = "green";
        rawValue = true;
        metadata = {
          display = "progress-short";
        };
      }
      {
        id = "7";
        type = "session-usage";
        metadata = {
          display = "time";
        };
      }
      {
        id = "8";
        type = "reset-timer";
      }
    ]
  ];
}
