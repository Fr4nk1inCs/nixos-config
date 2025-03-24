{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.homeManagerConfig;
  enable = cfg.gui.enable && cfg.gui.software.enable;
in {
  imports = [
    ./modules/ideavim.nix
  ];

  config.home.packages = lib.optionals enable (
    with pkgs;
      [
        # browser
        google-chrome
        # instant messaging
        telegram-desktop
        # remote code editing
        vscode
        code-cursor
        # file syncing
        gdrive3
        # image editing
        inkscape
        # academic research
        zotero
        # streaming
        moonlight-qt
        # online meeting
        zoom-us
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        # file syncing
        onedrive
        # screen capture
        obs-studio
        # video player
        mpv
        vlc
        # note taking
        obsidian
        # document viewer
        evince
        zathura
        # instant messaging
        qq
        # file explorer
        nautilus
        # system management
        baobab # disk usage analyzer
        # online meeting
        wemeet
        # RSS reader
        follow
        # password management
        bitwarden-desktop
        # subnet penetration
        zerotierone
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        # browser
        arc-browser
        # display management
        betterdisplay
        # app launcher
        raycast
        # menubar utility
        ice-bar
        stats
        # battery management
        aldente
        # pdf reader
        skimpdf
        # video player
        iina
      ]
  );
}
