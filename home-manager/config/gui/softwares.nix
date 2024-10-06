{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.homeManagerConfig;
  enable = cfg.gui.enable && cfg.gui.software.enable;
  programsForAllSystems = with pkgs; [
    # browser
    google-chrome
    # instant messaging
    telegram-desktop
    # streaming music
    spotify
    # remote code editing
    vscode
  ];
  programsForLinux = with pkgs; [
    # screen capture
    obs-studio
    # file syncing
    onedrive
    # document viewer
    evince
    zathura
    # note taking
    obsidian
    # video player
    mpv
    vlc
    # remote desktop
    parsec-bin
    # image editing
    inkscape
    # academic research
    zotero
    # instant messaging
    qq
    # file explorer
    nautilus
    # system management
    baobab # disk usage analyzer
  ];
  programsForDarwin = with pkgs; [
    # browser
    arc-browser
    # app launcher
    raycast
    # menubar utility
    ice-bar
    stats
    # battery management
    aldente
    # pdf reader
    skimpdf
    # input method
    sogou-pinyin-mac
  ];
  programs =
    programsForAllSystems
    ++ lib.optionals (cfg.system != "darwin") programsForLinux
    ++ lib.optionals (cfg.system == "darwin") programsForDarwin;
in {
  config.home.packages = lib.optionals enable programs;
}
