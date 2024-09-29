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
    zotero-beta
    # instant messaging
    qq
    # file explorer
    nautilus
    # system management
    baobab # disk usage analyzer
  ];
  programs =
    programsForAllSystems
    ++ lib.optionals (cfg.system != "darwin") programsForLinux;
in {
  config.home.packages = lib.optionals enable programs;
}
