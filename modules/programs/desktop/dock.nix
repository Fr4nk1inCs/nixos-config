{
  flake.modules.darwin.desktop = { pkgs, ... }: {
    system.defaults.dock = {
      orientation = "bottom";
      autohide = true;
      mru-spaces = false;
      persistent-apps = [
        "/System/Applications/Apps.app"
        "${pkgs.ghostty-bin}/Applications/Ghostty.app"
        "/Applications/Arc.app"
        "/Applications/QQ.app"
        "/Applications/WeChat.app"
        "/System/Applications/Mail.app"
        "${pkgs.zotero}/Applications/Zotero.app"
        "/System/Applications/Music.app"
        "/System/Applications/System Settings.app"
      ];
    };
  };
}
