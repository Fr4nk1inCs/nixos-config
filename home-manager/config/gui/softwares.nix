{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.profile.guiSoftwares) enable;
in {
  imports = [
    ./modules/ideavim.nix
    ./modules/zen-browser.nix
  ];

  config.home.packages = lib.optionals enable (
    with pkgs;
      [
        # instant messaging
        telegram-desktop
        # remote code editing
        vscode
        # file syncing
        gdrive3
        # image editing
        inkscape
        # academic research
        zotero
        # streaming
        moonlight-qt
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
        # knowledge base
        appflowy
        # document viewer
        evince
        zathura
        # instant messaging
        qq
        wechat
        # file explorer
        nautilus
        # system management
        baobab # disk usage analyzer
        # online meeting
        wemeet
        # RSS reader
        folo
        # password management
        bitwarden-desktop
        # subnet penetration
        tailscale
        # online meeting
        zoom-us
        # teamspeak
        teamspeak6-client
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
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
